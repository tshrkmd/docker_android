
### image作成

```
$ docker build -t tshrkmd/android:0.1 .
```

### ログイン

```
$ docker run -it tshrkmd/android:0.1 /bin/bash
```

### 起動中のコンテナにログイン

```
# docker psのNAMES
$ docker exec -it NAMES bash
```

### 実行

```
$ docker run -t -i -v `pwd`:/workspace tshrkmd/android:0.1 ./gradlew assembleDebug
```


### コンテナ一括削除

```
$ docker ps -a | awk '{print $1}' | tail -n +2 | xargs docker rm
```

