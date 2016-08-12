
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
$ mv local.properties local.properties.bk
$ docker run -t -i -v `pwd`:/workspace tshrkmd/android-build:0.1 start-emulator "./gradlew connectedAndroidTest"
$ mv local.properties.bk local.properties


```


### コンテナ一括削除

```
docker ps -a | awk '{print $1}' | tail -n +2 | xargs docker rm
```


docker run -i -t -d 53100891f685 /bin/bash

