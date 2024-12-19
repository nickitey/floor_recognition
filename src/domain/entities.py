from dataclasses import dataclass
from typing import Optional

from fastapi import UploadFile


@dataclass
class PlanImageFile:
    file: Optional[UploadFile]
    room_length: Optional[float]
