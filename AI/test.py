from flask import *
import sys
import os
import io
from stat import *
import fastai
from fastai import *
from fastai.vision import *
import base64
from flask_cors import CORS, cross_origin

# Khởi tạo server
app = Flask(__name__)
CORS(app)
# Khai báo đường dẫn thư mục
current_directory = os.getcwd()
path = Path(current_directory)
# path=Path('C:\\Users\\Admin\\PycharmProjects\\pythonProject')

# Load model
learner = load_learner(path, 'export.pkl')

# Khai bao ham xu ly request hello_word
@app.route('/hello_world', methods=['GET'])
@cross_origin()
def hello_world():
    # Lay staff id cua client gui len
    staff_id = request.args.get('staff_id')
    # Tra ve cau chao Hello
    return "Hello "  + str(staff_id)

@app.route('/')
@cross_origin()
def index():
    return "Welcome to flask API!"

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
    image = open_image('imageToSave.png').resize(224)
    pred_class, pred_idx, outputs = learner.predict(image)
    # Trả về dạng json của loại ô nhiễm
    # return jsonify(result_image=str(pred_class))
    to_float(outputs)
    if max(outputs)<0.9:
        return jsonify(result_image='Khong_O_Nhiem')
    else:
        return jsonify(result_image=str(pred_class))

@app.route('/test', methods=['POST'])
@cross_origin()
def test():
    b64=request.form.get('image')
    text=request.form.get('image')
    return text

# Thực thi server
if __name__ == "__main__":
    app.run(port=8000, debug=False)
    #  app.run(debug=False, host='0.0.0.0',port=my_port)