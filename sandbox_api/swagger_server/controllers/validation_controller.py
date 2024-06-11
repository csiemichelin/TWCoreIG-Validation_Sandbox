# -*- coding: UTF-8 -*-
import os
import json
import uuid
from flask import jsonify, request, make_response
from threading import Lock
from __main__ import file_status, verification_queue


# 用於生成6位數UUID的計數器和鎖
counter = 0
counter_lock = Lock()
def generate_short_uuid():
    global counter
    with counter_lock:
        counter += 1
        if counter > 999999:
            counter = 1
        # 取UUID的前4位和計數器的6位組成新的ID
        uuid_part = str(uuid.uuid4())[:4]
        counter_part = str(counter).zfill(6)
        return uuid_part + counter_part

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
        
def create_validations(body):
    body = request.get_json()
    bundles = body.get('bundles', [])
    for bundle in bundles:
        original_id = bundle.get('id', '')
        new_id = generate_short_uuid() + original_id
        bundle['id'] = new_id
        # 將表單加入到待驗證隊列中
        verification_queue.put((json.dumps(bundle), new_id))
        print_queue_contents(verification_queue)
        # print(f"昆霖測試 bundle: {bundle}")

    response = {
        "message": "Validations created successfully",
        "modified_bundles": bundles
    }
    return jsonify(response), 201