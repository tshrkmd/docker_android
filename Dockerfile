FROM ubuntu:16.04

ENV ANDROID_HOME=/usr/local/android-sdk-linux \
    ANDROID_SDK_VERSION=r25.2.5 \
    ANDROID_BUILD_TOOLS=26.0.2 \
    DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update \
    && apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 curl unzip openjdk-8-jdk --no-install-recommends && \
    apt-get clean

# Download and untar SDK
RUN curl -L https://dl.google.com/android/repository/tools_${ANDROID_SDK_VERSION}-linux.zip -o tools_${ANDROID_SDK_VERSION}-linux.zip  \
    && unzip -q tools_${ANDROID_SDK_VERSION}-linux.zip -d ${ANDROID_HOME}  \
    && rm -rf tools_${ANDROID_SDK_VERSION}-linux.zip
ENV PATH ${ANDROID_HOME}/emulator:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${PATH}

# Prepare sdkmanager
RUN mkdir -p $ANDROID_HOME/licenses/ \
    && echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > $ANDROID_HOME/licenses/android-sdk-license \
    && echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license \
    && mkdir ~/.android \
    && echo "count=0" > ~/.android/repositories.cfg

# Install sdk
RUN sdkmanager "tools" "platform-tools" "build-tools;${ANDROID_BUILD_TOOLS}" "platforms;android-26" \
    "system-images;android-25;google_apis;x86_64" \
    "extras;android;m2repository" "extras;android;m2repository" "extras;google;m2repository" "extras;google;google_play_services" \
    "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" \
    "extras;m2repository;com;android;support;constraint;constraint-layout-solver;1.0.2"

# Add tools from travis
ADD https://raw.githubusercontent.com/travis-ci/travis-cookbooks/master/community-cookbooks/android-sdk/files/default/android-wait-for-emulator /usr/local/bin/android-wait-for-emulator
RUN chmod +x /usr/local/bin/android-wait-for-emulator

# Create avd
RUN echo no | avdmanager -v create avd --force --name test --abi google_apis/x86_64 --package "system-images;android-25;google_apis;x86_64"

# WORKSPACE
RUN mkdir /workspace
WORKDIR /workspace
