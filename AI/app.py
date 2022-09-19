from flask import *
import sys
import os
import io
from stat import *
import fastai
from fastai import *
from fastai.vision import *
import cv2
import base64
import numpy as np

app=Flask(__name__)

# Khai báo đường dẫn thư mục
# current_directory = os.getcwd()
# path = Path(current_directory)
path=Path('C:\\Users\\Admin\\PycharmProjects\\pythonProject')
# Load model
learner = load_learner(path, 'export.pkl')

# Khai báo thư mục static để lưu ảnh tạm thời
app.config['UPLOAD_FOLDER'] = "C:\\Users\Admin\\PycharmProjects\\pythonProject\\static"

@app.route("/", methods=["GET", "POST"])
def predict_label():
    if request.method=="GET":
        # Trả về giao diện chính (home.html ở folder templates)
        return render_template("home.html")
    if request.method=="POST":
        # Khai báo biến img lấy file từ 'file' submit bên home.html
        img=request.files['file']
        # Khai báo đường dẫn lưu ảnh
        path_to_save = os.path.join(app.config['UPLOAD_FOLDER'], img.filename)
        # Lưu ảnh
        img.save(path_to_save)
        # Đọc ảnh, resize
        img= open_image(path_to_save).resize(224)
        # Xóa ảnh đã lưu xuống
        os.remove(path_to_save)

        # Phân loại ô nhiễm từ ảnh
        pred_class, pred_idx, utputs = learner.predict(img)

        # Trả về kết quả
        if str(pred_class) == 'O_Nhiem_Dat':
             return 'O nhiem dat'
        if str(pred_class) == 'O_Nhiem_Nuoc':
             return 'O nhiem nuoc'
        if str(pred_class) == 'O_Nhiem_Khong_Khi':
             return 'O nhiem khong khi'
        if str(pred_class) == 'Khong_O_Nhiem':
             return 'Khong o nhiem'

        # Trả về kiểu json
        # return jsonify(predictions=str(pred_class))

@app.route("/craftvillage/api/image/getpicture", methods=["GET", "POST"])
def predict_img():
    if request.method=="GET":
        # Trả về giao diện chính (home.html ở folder templates)
        return render_template("home.html")
    if request.method=="POST":
        # Khai báo biến img lấy file từ 'file' submit bên home.html
        img = request.files['file']
        # Khai báo đường dẫn lưu ảnh
        path_to_save = os.path.join(app.config['UPLOAD_FOLDER'], img.filename)
        # Lưu ảnh
        img.save(path_to_save)
        # Đọc ảnh, resize
        img = open_image(path_to_save).resize(224)
        # Xóa ảnh đã lưu xuống
        os.remove(path_to_save)

        # Phân loại ô nhiễm từ ảnh
        pred_class, pred_idx, outputs = learner.predict(img)

        return jsonify(predictions=str(pred_class))

print('Hello')
if __name__ == "__main__":
    app.run(port=8081, debug=False)