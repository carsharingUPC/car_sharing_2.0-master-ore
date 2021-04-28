class Usuario {
  final int id;
  final String apellidoMaterno;
  final String apellidoPaterno; 
  final String celular;
  final String correo;
  final String dni;
  final bool enable;
  final bool esAdm;
  final String fechaNac;
  final String nombres;
  final String password;

  Usuario(this.id, this.apellidoMaterno, this.apellidoPaterno, this.celular, this.correo,
      this.dni, this.enable, this.esAdm, this.fechaNac, this.nombres, this.password);
}