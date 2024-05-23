import os
import time

# Path to the file to keep busy
file_path = "C:\\Users\\admin\\Desktop\\devops\\tempDir\\testT10.json"

# Open the file in read mode to keep it busy
with open(file_path, 'r+') as file:
    print(f"{file_path} is now being used. Press Ctrl+C to exit.")
    try:
        while True:
            # Keep the file open and write to it periodically
            file.seek(0, os.SEEK_END)
            file.write("\n")
            file.flush()
            time.sleep(1)
    except KeyboardInterrupt:
        print("\nExiting and stopping the file usage.")
