# @version ^0.3.7
interface ContratoPrestamo:
    def setSolicitudAsPrestamo(codigoSolicitud:String [36]): nonpayable
    def estadoPrestamo(codigoPrestamo: String[36]) -> Prestamo: view
    def guardarSolicitud(solicitud: Solicitud): nonpayable
    
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

owner: address
libros: HashMap[String[36], Libro]
solicitudes: HashMap[String[36], Solicitud]


@external
def setLibroPrestado(codigoSolicitud: String[36], idLibroSolicitado: String[36], prestador: address):
    solicitud: Solicitud = Solicitud({
        codigoSolicitud: codigoSolicitud,
        idLibro: idLibroSolicitado,
        solicitante: msg.sender,
        estado: EstadoSolicitud.ENVIADA
    })
    prestamo: ContratoPrestamo = ContratoPrestamo(prestador)
    prestamo.guardarSolicitud(solicitud)
    prestamo.setSolicitudAsPrestamo(solicitud.codigoSolicitud)
    

@view
@external
def estadoSolicitud(codigoSolicitud: String[36]) -> Solicitud:
    solicitud: Solicitud = self.solicitudes[codigoSolicitud]
    assert solicitud.solicitante!= empty(address), "No se encuentra solicitud"
    return solicitud