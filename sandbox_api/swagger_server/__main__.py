import os
import ssl
import json
import connexion
from queue import Queue
from swagger_server import encoder
from flask_apscheduler import APScheduler
from threading import Thread, Lock

# 全局變量，保存每個文件的狀態（是否空閒）
file_status = {f'test/bundle-{i:02}.json': 'idle' for i in range(1, 11)}
# 創建一個隊列來存儲待驗證的 JSON 表單
verification_queue = Queue()
context = ssl.SSLContext()

# 創建一個鎖來保護 file_status(後面的變更file_status_lock操作要等待前面的操作完成)
file_status_lock = Lock()

def create_app():
    context.load_cert_chain("cert.pem", "key.pem")

    app = connexion.FlaskApp(__name__, specification_dir="swagger/")
    app.json_encoder = encoder.JSONEncoder
    app.json_encoder.ensure_ascii = False
    app.json_encoder.encoding = "utf-8"

    app.add_api(
        "swagger.yaml",
        arguments={"title": "Judicial 30X API", "swagger_ui": False},
        pythonic_params=True,
    )

    return app

# 判定字串是否合規json格式
def is_valid_json_string(json_string):
    try:
        json.loads(json_string)
        return True
    except (ValueError, json.JSONDecodeError) as e:
        print(f"Invalid JSON string: {e}")
        return False
    
# 判定文件是否包含合法的 JSON
def is_valid_json_file(file_path):
    try:
        with open(file_path, 'r') as f:
            data = f.read()
        json.loads(data)
        return True
    except (ValueError, json.JSONDecodeError, FileNotFoundError) as e:
        print(f"Invalid JSON or file not found in {file_path}: {e}")
        return False

def print_queue_contents(queue):
    temp_list = []
    while not queue.empty():
        item = queue.get()
        temp_list.append(item)
    
    print("Queue contents:")
    for item in temp_list:
        print(item)
    
    for item in temp_list:
        queue.put(item)

# 尋找空閒的文件路徑
def find_idle_file():
    with file_status_lock:
        for file_path, status in file_status.items():
            if status == 'idle':
                return file_path
    return None

def check_ouput_file_exist():
    return None

# 監控有沒有需要將文件調整狀態為idle，TODO當是JSON格式的input文件，則檢查有沒有相對應的ouput文件:[request.id]_output.json，且該json也符合json格式，則將其轉成idle
def changeto_idle_file():
    with file_status_lock:
        for file_path in file_status.keys():
            if is_valid_json_file(file_path) and file_status[file_path] == 'busy':
                file_status[file_path] = 'idle'
                print(f"{file_path} is valid JSON and marked as idle.")
        
# 監控文件變化調整狀態為idle，並觸發驗證會複寫idle的檔案
def monitor_files():
    # 監控有沒有需要將input文件調整狀態為idle(檢查ouput文件是否寫到[request.id]_output.json)
    changeto_idle_file()
    print_queue_contents(verification_queue)
    print("file_status: " + str(file_status))
    if not verification_queue.empty():
        json_form = verification_queue.get()
        bundle_json, request_id = json_form
        file_path = find_idle_file()
        if file_path != None:
            if is_valid_json_string(bundle_json) and file_status[file_path] == 'idle': # 若json合規則要把檔案狀態改為busy開始進行複寫
                with file_status_lock:
                    file_status[file_path] = 'busy'
                with open(file_path, 'w') as f:
                    f.write(bundle_json)
                # print("file_status: " + str(file_status))
                print(f'Assigned form to {file_path}')
            else:   # 不合規則要往下個idle input去寫
                print(f"Invalid JSON in {file_path} and marked as idle.")
                with file_status_lock:
                    file_status[file_path] = 'idle'

if __name__ == "__main__":
    app = create_app()

    # Initialize the scheduler with the actual Flask application instance
    scheduler = APScheduler()
    scheduler.init_app(app.app)
    scheduler.start()
    
    # Add scheduled task
    scheduler.add_job(id='ScheduledTask', func=monitor_files, trigger='interval', seconds=3)

    # Run the Flask application
    api_port = 10000
    app.run(debug=True, ssl_context=context, port=api_port, threaded=True)
