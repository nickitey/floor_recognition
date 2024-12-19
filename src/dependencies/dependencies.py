from src.data.repositories import ARFileRepository
from src.domain.usecases import RecognizePlanUseCase


class Container:
    convert_plan_usecase = RecognizePlanUseCase(ARFileRepository)
