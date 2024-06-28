# TWCoreIG-Validation_Sandbox
衛服部次世代專案，檢查FHIR餵進來的Bundles body，是否符合TW Core IG和FHIR的Resource表單規範。

將validator_cli.jar放到指定sandbox_api目錄位置  
執行server: sudo python3 -m swagger_server  
執行script寫入cli_message(判斷是否驗證完畢)     
啟動MongoDB綁定IP: mongod --bind_ip localhost,52-0B20626-H1  