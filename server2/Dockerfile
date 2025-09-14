FROM python:3.11-slim

# 작업 디렉토리 설정
WORKDIR /app

# 앱 파일 복사
COPY . /app

# 의존성 설치
RUN pip install --no-cache-dir -r requirements.txt

# 컨테이너에서 열어줄 포트
EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]