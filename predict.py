from keras.models import Sequential,load_model
from keras.layers import Conv2D,MaxPool2D
from keras.layers import Activation ,Dropout ,Flatten, Dense
from keras.utils import np_utils
import keras,sys
from PIL import Image #画像処理のセット
import numpy as np
from sklearn import model_selection #クロスバリデーション（交差検証）用の関数

classes = ["monkey","boar","crow","men","women"]
num_classes = len(classes) #格納された画像の数を数える。
image_size = 50 #画像サイズを小さくする。

def build_model():
    model = Sequential()  # (系列) モデルをシーケンシャルで作成　シーケンシャルモデルは層を積み重ねたもの。

    # 一層目を作成

    model.add(Conv2D(32, (3, 3), padding='same', input_shape=(50,50,3)))  # xtrainの（450,50,50,3）の1以降を取り出す。今まではinput_shape=x.shape[1:]だったが、手動で入力する。
    # #・3 x 3 のサイズの32個のフィルタによる畳み込みを行う➡フィルタは様々な処理でデータを抽出しやすくするものだと思う。https://imagingsolution.net/imaging/filter-algorithm/・入力画像と出力画像サイズが同じになるように（上下左右に）ゼロパディングを行う・X_trainの行列は {画像の個数 x R x G x Bの濃さ} というデータが入っているが、R,G,Bの部分の形状を入力データの形状とする
    # X_train ➡(450,50,50,3)➡（50,50,3）が取り出せる。のデータが入っており、個数以下のデータの取り出しが必要なので、input_shape=X_train[1:]　※2より後ろ　とする。

    model.add(Activation('relu'))  # 活性化関数

    # 二層目

    model.add(Conv2D(32, (3, 3)))
    model.add(Activation('relu'))
    model.add(MaxPool2D(pool_size=(2, 2)))  # MAXプーリング。画像を圧縮することで、計算コストを下げるなどの効果がある。プールサイズを[2x2]のエリアで一番大きい値を取り出す（特徴抽出）
    model.add(Dropout(0.25))  # ドロップアウト関数　ランダムでデータを切り捨て過学習を避ける。

    model.add(Conv2D(64, (3, 3), padding='same'))  # 64個のカーネル（フィルタ）で、畳み込み結果が同じサイズになるようにピクセル左右すに足す指定
    model.add(Activation('relu'))
    model.add(Conv2D(64, (3, 3)))
    model.add(Activation('relu'))
    model.add(MaxPool2D(pool_size=(2, 2)))  # MAXプーリング。画像を圧縮することで、計算コストを下げるなどの効果がある。プールサイズを[2x2]のエリアで一番大きい値を取り出す（特徴抽出）
    model.add(Dropout(0.25))  # ドロップアウト関数　ランダムでデータを切り捨て過学習を避ける。

    model.add(Flatten())
    model.add(Dense(512))  # 全層結合　もとは３だったが・・・よくわからん。
    model.add(Activation('relu'))
    model.add(Dropout(0.5))  # ドロップアウト関数　ランダムでデータを切り捨て過学習を避ける。

    model.add(Dense(5))  # 答えが5つに分かれるので、5だそうだ。
    model.add(Activation('softmax'))

    # 最適化　・・損失関数を一番少なくするための計算

    opt = keras.optimizers.rmsprop(lr=0.0001,
                                   decay=1e-6)  # optimaizer・・トレーニング時の更新アルゴリズム lr・・ラーニングレート　学習率　毎計算の幅 　decay・・学習率を下げる。1e-6　10の何乗か

    model.compile(loss='categorical_crossentropy', optimizer=opt, metrics=['accuracy'])
    # optimaizer 最適化アルゴリズム　categorical_crossentropyは交差エントロピー誤差というアルゴリズムを指定しています。　loss 損失関数　metrics・・評価手法

    #model.fit(x, y, batch_size=32, epochs=100)  #トレーニングの実行　今回は必要ない# batch_sizeランダムで取り出す画像数 epoch 実験回数　数を増やすと精度が上がる。マシンが遅い場合は下げてもいい。

    model = load_model('./animal_cnn_aug.h5') #モデルのロード kerasに含まれている

    return model

def main():
    image = Image.open("1536243469472.jpg") #なんかうまくいかないので、ここに直接打ち込んだ
    image = image.convert('RGB')
    image = image.resize((image_size,image_size))
    data = np.asarray(image)#numpyの配列に変換
    X=[]
    X.append(data)
    X=np.array(X)
    model = build_model()

    result = model.predict([X])[0] #推定結果を得る 予想結果が配列になっている。
    predicted = result.argmax() #推定値の中で、最も推定値の大きいものを得る
    percentage = int(result[predicted]*100)
    print("{0}({1}%)".format(classes[predicted],percentage))#format関数を使うと、{0},{1}のところに変数を入れ込むことができる。

if __name__ == "__main__": #このファイルを他のファイルでimportしたときに自動実行されないためのおまじない。__name__はファイル名が自動で入れられる。
    # しかし、python hello.py のようにプログラムを実行した場合、 hello.py の内部の __name__ 変数は "__main__" という文字列になります。
    main()
