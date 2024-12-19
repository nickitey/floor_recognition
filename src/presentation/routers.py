from typing import Annotated, Optional

from fastapi import APIRouter, Depends, Header, UploadFile, status
from fastapi.responses import JSONResponse

from src.dependencies.dependencies import Container
from src.domain.entities import PlanImageFile
from src.domain.usecases import RecognizePlanUseCase
from src.presentation.requests import ARConverterRequest

router = APIRouter(prefix="/recognition", tags=["AR-Convertion"])


@router.post("")
async def make_convertion(
    x_room_length: Annotated[Optional[str], Header()],
    file: UploadFile,
    usecase: RecognizePlanUseCase = Depends(Container),
) -> JSONResponse:
    # Создание Pydantic-модели для валидации, что файл существует
    uploaded_data = ARConverterRequest(file=file, room_length=x_room_length)

    plan_object = PlanImageFile(file=uploaded_data.file, room_length=uploaded_data.room_length)

    # Запускаем конвертер. За счет низкой связанности, логика конвертации
    # может быть абсолютно разной, это никак не повлияет на логику API.
    convertion_status: bool = await usecase.convert_file_usecase.invoke(
        plan_object
    )

    # Подготовим ответ.
    response: JSONResponse = JSONResponse(
        {"status": "Успешно"} if convertion_status else {"status": "Неудачно"},
        status_code=(
            status.HTTP_201_CREATED
            if convertion_status
            else status.HTTP_204_NO_CONTENT
        ),
    )
    return response
