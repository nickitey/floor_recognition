from src.domain.entities import PlanImageFile
from src.domain.repositories import IPlanRecognitionRepository


class ARFileRepository(IPlanRecognitionRepository):
    async def convert(self, plan_file: PlanImageFile):
        return True
