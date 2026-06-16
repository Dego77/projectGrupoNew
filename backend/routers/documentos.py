from pathlib import Path

from fastapi import (
    APIRouter,
    Depends,
    UploadFile,
    File,
    Form
)

from sqlmodel import Session, select

from models import DocumentoProyecto
from database_empresa import get_session_empresa


router = APIRouter(
    prefix="/documentos",
    tags=["Documentos"]
)


@router.post("/subir")
async def subir_documento(

    archivo: UploadFile = File(...),

    nombre: str = Form(...),

    tipo: str = Form(...),

    formato: str = Form(...),

    tamano: str = Form(...),

    id_proyecto: int = Form(1),

    session: Session = Depends(get_session_empresa)

):

    carpeta = Path("uploads/documentos")

    carpeta.mkdir(
        parents=True,
        exist_ok=True
    )

    ruta_archivo = carpeta / archivo.filename

    contenido = await archivo.read()

    with open(ruta_archivo, "wb") as f:
        f.write(contenido)

    documento = DocumentoProyecto(

        id_proyecto=id_proyecto,

        nombre=nombre,

        tipo=tipo,

        archivo_url=str(ruta_archivo),

        tamano=tamano,

        formato=formato

    )

    session.add(documento)

    session.commit()

    session.refresh(documento)

    return documento


@router.post("/")
def crear_documento(
    documento: DocumentoProyecto,
    session: Session = Depends(get_session_empresa)
):

    session.add(documento)

    session.commit()

    session.refresh(documento)

    return documento


@router.get("/")
def listar_documentos(
    session: Session = Depends(get_session_empresa)
):

    return session.exec(
        select(DocumentoProyecto)
    ).all()


@router.delete("/{id_documento}")
def eliminar_documento(
    id_documento: int,
    session: Session = Depends(get_session_empresa)
):

    documento = session.get(
        DocumentoProyecto,
        id_documento
    )

    if documento:

        session.delete(documento)

        session.commit()

    return {"ok": True}