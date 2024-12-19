from typing import Optional

from fastapi import UploadFile, status
from pydantic import BaseModel, field_validator

from src.core.exceptions import PlanRecognitionException


class ARConverterRequest(BaseModel):
    room_length: Optional[str]
    file: Optional[UploadFile]

    @field_validator("extension")
    @classmethod
    def extension_is_correct(cls, ext):
        if ext is None:
            raise PlanRecognitionException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail="Please provide X-Room-Length request header.",
            )
        try:
            return float(ext)
        except ValueError:
            raise PlanRecognitionException(
                status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
                detail="Please provide correct value for X-Room-Length request header (integer or float)."
            )

    @field_validator("file")
    @classmethod
    def file_is_present(cls, file):
        if file is None:
            raise PlanRecognitionException(
                status_code=status.HTTP_400_BAD_REQUEST,
                detail="Please provide plan to recognize.",
            )
        return file
