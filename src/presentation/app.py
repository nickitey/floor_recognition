from fastapi import APIRouter, FastAPI

from src.core.settings import Settings
from src.presentation.routers import router

settings = Settings()


def _create_app(router: APIRouter):
    app = FastAPI(
        title="Room plan ML-recognition API",
        description="This service provides online technical plan of a room ML-recognition",
        docs_url="/docs" if settings.app.mount_swagger else None,
        redoc_url="/redoc" if settings.app.mount_redoc else None,
        openapi_url=(
            "/openapi.json"
            if settings.app.mount_swagger or settings.app.mount_redoc
            else None
        ),
    )

    app.include_router(router)
    return app


app = _create_app(router)
