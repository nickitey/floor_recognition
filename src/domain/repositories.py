import abc

from src.domain.entities import PlanImageFile

class IPlanRecognitionRepository(abc.ABC):
    @abc.abstractmethod
    async def convert(self, plan_entity: PlanImageFile): ...
