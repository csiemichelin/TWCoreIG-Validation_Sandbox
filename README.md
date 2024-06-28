# TWCoreIG-Validation_Sandbox
衛服部次世代專案，檢查FHIR餵進來的Bundles body，是否符合TW Core IG和FHIR的Resource表單規範。

* 創建Sandbox API，將bundle資訊放到body內，當API呼叫時會將bundle放到Queue中  
* 使用Flak + APScheduler實現monitor，此monitor會透過排程器每隔一段時間將Queue中需要驗證的bundle加到狀態為idle(此狀態會透過Lock保護)的input文件內  
* 有一個scirpt會並行的跑10個cli指令，負責將input文件做驗證處理  
* 此專案資料庫採用MongoDB進行存取，每個document欄位包含: _id, request_id, bundle_ids, create_time, validation_message  

將validator_cli.jar放到指定sandbox_api目錄位置  
執行server: sudo python3 -m swagger_server  
執行script寫入cli_message(判斷是否驗證完畢)     
啟動MongoDB綁定IP: mongod --bind_ip localhost,52-0B20626-H1  
