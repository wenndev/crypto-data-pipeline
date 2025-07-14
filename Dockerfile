# Usa a imagem slim do Python 3.11
FROM python:3.11-slim-bookworm

# Define o diretório de trabalho
WORKDIR /app

# Instala dependências do sistema e o Poetry
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    build-essential \
    && curl -sSL https://install.python-poetry.org | python3 - --version 1.8.2 \
    && chmod +x /root/.local/bin/poetry \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Adiciona Poetry ao PATH
ENV PATH="/root/.local/bin:$PATH"

# Configura o Poetry para não criar virtualenv (melhor para containers)
RUN poetry config virtualenvs.create false

# Copia primeiro os arquivos de dependência (otimiza cache do Docker)
COPY pyproject.toml poetry.lock ./

# Instala dependências do projeto
RUN poetry install --no-root --no-interaction --no-ansi --no-cache

# Cria um usuário não-root para maior segurança
RUN useradd -m appuser 
USER appuser

# Copia o resto dos arquivos
COPY  src/ src/
COPY  streamlit_app/ /app/streamlit_app/
COPY .env /app/.env

# Define o comando padrão
#CMD ["bash", "-c", "streamlit run /app/streamlit_app/app.py"]

