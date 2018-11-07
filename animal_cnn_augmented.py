from keras.models import Sequential
from keras.layers import Conv2D,MaxPool2D
from keras.layers import Activation ,Dropout ,Flatten, Dense
from keras.utils import np_utils
import keras

import numpy as np

classes = ["monkey","boar","crow","men","women"]
num_classes = len(classes) #格納された画像の数を数える。
image_size = 50 #画像サイズを小さくする。

#メインの関数を定義する。
def main():
    X_train,X_test,y_train,y_test = np.load("./animal_aug.npy") #gen_data で作成したnpyデータ配列の読み込み ./は同じ階層
    X_train = X_train.astype("float")/256 #正規化　０～１にデータが収まる方がぶれが少ないので最大値で割る。 astype・・小数にキャスト
    X_test = X_test.astype("float")/256
    y_train = np_utils.to_categorical(y_train,num_classes) #one-hot-vector 正解値は１、他は⓪とする
    y_test = np_utils.to_categorical(y_test,num_classes)
    model = model_train(X_train,y_train)
    print(X_train[0], y_train[0])
    model_eval(model,X_test,y_test)#モデルを評価する関数model_eval() 引数　（モデル、x_テスト、yテスト）

def model_train(x,y):
    model = Sequential() # (系列) モデルをシーケンシャルで作成　シーケンシャルモデルは層を積み重ねたもの。

    # 一層目を作成

    model.add(Conv2D(32,(3,3), padding ='same',input_shape=x.shape[1:])) #xtrainの（450,50,50,3）の1以降を取り出す。多分、50（色の濃さ）*50(濃さ)*3種類(R*G*B)かな？
    # #・3 x 3 のサイズの32個のフィルタによる畳み込みを行う➡フィルタは様々な処理でデータを抽出しやすくするものだと思う。https://imagingsolution.net/imaging/filter-algorithm/・入力画像と出力画像サイズが同じになるように（上下左右に）ゼロパディングを行う・X_trainの行列は {画像の個数 x R x G x Bの濃さ} というデータが入っているが、R,G,Bの部分の形状を入力データの形状とする
    #X_train ➡(450,50,50,3)➡（50,50,3）が取り出せる。のデータが入っており、個数以下のデータの取り出しが必要なので、input_shape=X_train[1:]　※2より後ろ　とする。

    model.add(Activation('relu'))#活性化関数


    #二層目

    model.add(Conv2D(32,(3,3)))
    model.add(Activation('relu'))
    model.add(MaxPool2D(pool_size=(2,2)))#MAXプーリング。画像を圧縮することで、計算コストを下げるなどの効果がある。プールサイズを[2x2]のエリアで一番大きい値を取り出す（特徴抽出）
    model.add(Dropout(0.25)) #ドロップアウト関数　ランダムでデータを切り捨て過学習を避ける。

    model.add(Conv2D(64,(3,3),padding='same'))    #64個のカーネル（フィルタ）で、畳み込み結果が同じサイズになるようにピクセル左右すに足す指定
    model.add(Activation('relu'))
    model.add(Conv2D(64,(3,3)))
    model.add(Activation('relu'))
    model.add(MaxPool2D(pool_size=(2, 2)))  # MAXプーリング。画像を圧縮することで、計算コストを下げるなどの効果がある。プールサイズを[2x2]のエリアで一番大きい値を取り出す（特徴抽出）
    model.add(Dropout(0.25))  # ドロップアウト関数　ランダムでデータを切り捨て過学習を避ける。

    model.add(Flatten())
    model.add(Dense(512)) #全層結合　もとは３だったが・・・よくわからん。
    model.add(Activation('relu'))
    model.add(Dropout(0.5))  # ドロップアウト関数　ランダムでデータを切り捨て過学習を避ける。

    model.add(Dense(5)) # 答えが5つに分かれるので、5だそうだ。
    model.add(Activation('softmax'))

    #最適化　・・損失関数を一番少なくするための計算

    opt = keras.optimizers.rmsprop(lr=0.0001,decay=1e-6) #optimaizer・・トレーニング時の更新アルゴリズム lr・・ラーニングレート　学習率　毎計算の幅 　decay・・学習率を下げる。1e-6　10の何乗か

    model.compile(loss='categorical_crossentropy',optimizer= opt,metrics=['accuracy'])
    #optimaizer 最適化アルゴリズム　categorical_crossentropyは交差エントロピー誤差というアルゴリズムを指定しています。　loss 損失関数　metrics・・評価手法

    model.fit(x,y,batch_size=32,epochs=100) #batch_sizeランダムで取り出す画像数 epoch 実験回数　数を増やすと精度が上がる。マシンが遅い場合は下げてもいい。

    model.save('./animal_cnn_aug.h5') #モデルの保存

    return model

def model_eval(model,x,y): #損失値の計算#モデルの評価 x,yには、mainのmodel_eval(model, X_test, y_test)が入っている。
    scores = model.evaluate(x,y,verbose=1)#verbose バーバスモード　途中の経過を表示するモードを有効化
    print('Test Loss',scores[0]) #socoreの0番目には損失値(1-損失値)が入っている
    print('Test Accuracy',scores[1]) #accuracy・・精度

if __name__ == "__main__":
    main()
