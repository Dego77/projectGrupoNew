from fastapi import APIRouter, Depends
from sqlmodel import Session, select

from models import AvanceProyecto
from database_empresa import get_session_empresa

router = APIRouter(
    prefix="/avances",
    tags=["Avances de Proyecto"]
)


@router.post("/")
def registrar_avance(
    avance: AvanceProyecto,
    session: Session = Depends(get_session_empresa)
):

    session.add(avance)

    session.commit()

    session.refresh(avance)

    return avance


@router.get("/")
def listar_avances(
    session: Session = Depends(get_session_empresa)
):

    return session.exec(
        select(AvanceProyecto)
    ).all()


@router.get("/proyecto/{id_proyecto}")
def avances_proyecto(
    id_proyecto: int,
    session: Session = Depends(get_session_empresa)
):

    return session.exec(
        select(AvanceProyecto)
        .where(
            AvanceProyecto.id_proyecto == id_proyecto
        )
    ).all()