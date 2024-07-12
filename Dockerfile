FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-runtime
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /opt/

RUN apt-get update -y
RUN apt-get -y install git unzip git-lfs
RUN git lfs install
RUN git clone --recursive https://github.com/FunAudioLLM/CosyVoice.git
# here we use python==3.10 because we cannot find an image which have both python3.8 and torch2.0.1-cu118 installed
RUN cd CosyVoice && pip3 install -r requirements.txt
RUN cd CosyVoice/runtime/python/grpc && python3 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. cosyvoice.proto

RUN mkdir -p pretrained_models && \
    git clone https://www.modelscope.cn/iic/CosyVoice-300M.git pretrained_models/CosyVoice-300M && \
    git clone https://www.modelscope.cn/iic/CosyVoice-300M-SFT.git pretrained_models/CosyVoice-300M-SFT && \
    git clone https://www.modelscope.cn/iic/CosyVoice-300M-Instruct.git pretrained_models/CosyVoice-300M-Instruct && \
    git clone https://www.modelscope.cn/iic/CosyVoice-ttsfrd.git pretrained_models/CosyVoice-ttsfrd
