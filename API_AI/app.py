from flask import *
import sys
import os
import io
from stat import *
#import fastai
#from fastai import *
#from fastai.vision import *
#from fastai.imports import *
from fastai.vision.all import *
import base64
from flask_cors import CORS, cross_origin
from joblib import load
import json
import numpy as np
import pandas as pd

import pathlib
#temp = pathlib.PosixPath
#pathlib.PosixPath = pathlib.WindowsPath

# Khởi tạo server
app = Flask(__name__)
CORS(app)
# Khai báo đường dẫn thư mục
#current_directory = os.getcwd()
#path = Path(current_directory)

# Load model
learner = load_learner('/root/API_AI/export.pkl')
random_forest = load('/root/API_AI/random_forest.joblib')


# Convert json to DataFrame
def convert_json_to_dataframe(data):
    array = [181, 178, 39, 35, 32, 36, 78, 77, 182, 191, 180, 34, 67, 66, 63, 84, 82, 81]
    new_array = []
    my_json_string = json.dumps(data)
    question_data = json.loads(my_json_string)
    questions = question_data["data"]

    for i in range(len(array)):
        for question in questions:
            id = question["questionId"]
            if (id == array[i]):
                answer = question["answer"]
                if (id == 35 or id == 32 or id == 36 or id == 77 or id == 34):
                    if (answer[0]["count"] >= 1 and answer[0]["value"] == "Có"):
                        new_array.append(1)
                    else:
                        new_array.append(2)
                elif (id == 66 or id == 67):
                    x = 0
                    if (answer[0]["count"] >= 1):
                        if (answer[0]["value"] == "<20%"):
                            x = 10
                        elif (answer[0]["value"] == "20% - 40%"):
                            x = 30
                        elif (answer[0]["value"] == "40%- 60%"):
                            x = 50
                        elif (answer[0]["value"] == "60% - 80%"):
                            x = 70
                        elif (answer[0]["value"] == "> 80%"):
                            x = 90
                    new_array.append(x)
                else:
                    if (answer[0]["count"] >= 1):
                        new_array.append(float(answer[0]["value"]))
                    else:
                        new_array.append(0)

    x = np.array(new_array)
    feature_names = ["Lượng khí ga đã sử dụng", "Lượng than đã sử dụng", "Đốt cháy", "Sử dụng khí ga",
                     "Sử dụng than", "Sử dụng dầu", "Tỷ lệ nước thải được thu gom và xử lý tại nhà máy",
                     "Có nhà máy xử lý nước thải nào tại xã không?", "Lượng dầu đã sử dụng",
                     "Lượng nước đầu vào", "Lượng chất thải rắn đã sử dụng",
                     "Sử dụng chất thải rắn làm nhiên liệu", "Tỷ lệ không được thu gom",
                     "Tỷ lệ được thu mua", "Lượng chất thải sinh hoạt trung bình của hộ gia đình",
                     "Tỷ lệ: tái chế", "Tỷ lệ: bãi rác tập trung", "Tỷ lệ: bãi rác địa phương"]

    df = pd.DataFrame(data=x.reshape(1, -1), columns=feature_names)
    return df

# Define API endpoint
@app.route('/predict', methods=['POST'])
def predict():
    # Get input data from request
    data = request.get_json(force=True)

    # Convert input data to DataFrame
    df = convert_json_to_dataframe(data)

    # Make prediction using model
    prediction = random_forest.predict(df)

    # Convert prediction to list and return as JSON response
    output = ''.join(map(str, prediction.tolist()[0]))
    return output

# Khai báo hàm xử lý request detect
@app.route('/detect', methods=['POST'])
@cross_origin()
def predict_img():
    requestData = json.loads(request.data.decode('utf-8'))
    # Lấy dữ liệu image dạng base64
    # b64 = request.form.get('image')
    b64 = requestData['image']
    # Chuyển về dạng bytes
    b64 = bytes(b64, 'utf-8')
    # Chuyển thành ảnh imageToSave.png
    with open("imageToSave.png", "wb") as fh:
        fh.write(base64.decodebytes(b64))
    # Đọc ảnh từ imageToSave.png và phân loại ô nhiễm
    image = 'imageToSave.png'
    pred_class, pred_idx, outputs = learner.predict(image)
    # Trả về dạng json của các loại ô nhiễm
    result = {'nomal':round(float(outputs[1])*100,4), 'air_pollution':round(float(outputs[0])*100,4), 'soil_pollution':round(float(outputs[2])*100,4), 'water_pollution':round(float(outputs[3])*100,4)}
    return result

# Thực thi server
if __name__ == "__main__":
    # app.run(host="http://150.95.113.16", port=8000, debug=False) #server host
     app.run(debug=False, host='0.0.0.0',port=8000)