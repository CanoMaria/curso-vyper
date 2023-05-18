# @version ^0.3.7

enum EstadoLibro:
    EN_STOCK
    PRESTADO

enum EstadoPrestamo:
    VIGENTE
    VENCIDO
    DEVUELTO

enum EstadoSolicitud:
    ENVIADA
    APROBADA
    RECHAZADA

struct Libro:
    idLibro: String[36]
    titulo: String[36]
    estado: EstadoLibro

struct Prestamo:
    codigoPrestamo: String[36]
    idLibro: String[36]
    fechaPrestamo: uint256
    fechaVencimiento: uint256
    fechaDevolucion: uint256
    prestador: address
    solicitante: address
    estadoPrestamo: EstadoPrestamo

struct Solicitud:
    codigoSolicitud: String[36]
    idLibro: String[36]
    solicitante: address
    estado: EstadoSolicitud

prestamos: HashMap[String[36], Prestamo]
solicitudes: HashMap[String[36], Solicitud]
libros: HashMap[String[36], Libro]
owner: address

@external
def __init__():
    self.owner = msg.sender

@external
def nuevoLibro(idLibro: String[15],titulo: String[36]):
    assert self.libros[idLibro].idLibro == "","El libro ya existe con ese id"
    nuevoLibro: Libro = Libro({
        idLibro: idLibro,
        titulo: titulo,
        estado: EstadoLibro.EN_STOCK
    })
    self.libros[idLibro]=nuevoLibro
    assert self.libros[idLibro].idLibro != "","No se guardo el libro"

@external
def guardarSolicitud(solicitud: Solicitud):
    self.solicitudes[solicitud.codigoSolicitud]=solicitud

#funcion que hace verificaciones y llama a guardar
@external
def setSolicitudAsPrestamo(codigoSolicitud: String [36]):
    solicitudRecibida: Solicitud = self.solicitudes[codigoSolicitud]
    assert solicitudRecibida.solicitante != empty(address), "Solicitud no registrada"
    #assert msg.sender == self.owner, "Esta operación solo puede ser realizada por el owner"
    assert self.libros[solicitudRecibida.idLibro].idLibro != '', "El libro no existe"
    libro: Libro = self.libros[solicitudRecibida.idLibro]
    if(libro.estado == EstadoLibro.PRESTADO):
        solicitudRecibida.estado = EstadoSolicitud.RECHAZADA
        self.solicitudes[codigoSolicitud]=solicitudRecibida
    assert libro.estado == EstadoLibro.EN_STOCK, "No se puede prestar un libro ya prestado"
    
    nuevoPrestamo: Prestamo = Prestamo({
        codigoPrestamo: codigoSolicitud,
        idLibro: solicitudRecibida.idLibro,
        fechaPrestamo: block.timestamp,
        fechaVencimiento: block.timestamp + 7 * 24 * 60 * 60,
        fechaDevolucion: 0,
        prestador: self.owner,
        solicitante: solicitudRecibida.solicitante,
        estadoPrestamo: EstadoPrestamo.VIGENTE
    })
    solicitudRecibida.estado = EstadoSolicitud.APROBADA
    self.solicitudes[codigoSolicitud]=solicitudRecibida

    prestamo: Prestamo = self.prestamos[nuevoPrestamo.codigoPrestamo]
    assert prestamo.codigoPrestamo == '', "El préstamo ya existe."
    self.prestamos[nuevoPrestamo.codigoPrestamo] = prestamo
    


