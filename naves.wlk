class Nave{ //Clase Abastracta, porque tiene al menos 1 método abstracto
	var velocidad = 0

	method velocidad() = velocidad

	method propulsar(){
		self.acelerar(20000)
	}

	method acelerar(cantidad){
		velocidad = (velocidad + cantidad).min(300000)
	}

	/*Es un método abstracto porque no tiene cuerpo. Esto obliga a que sus subclases, 
	para poder instanciarse deban implementarlo!*/
	method recibirAmenaza()

	method preparar(){
		self.acelerar(15000)	
		self.prepararExtra()
	}

	method prepararExtra(){
		//La mayoria no hacen nada! entonce no es abstracto.
	}

	method encontrarEnemigo(){
		self.recibirAmenaza()
		self.propulsar()
	}
}

class NaveDeCarga inherits Nave{
	var property carga = 0

	method sobrecargada() = carga > 100000

	method excedidaDeVelocidad() = velocidad > 100000
	
	override method recibirAmenaza(){
		carga = 0
	}
}

class NaveDeResiduos inherits NaveDeCarga{
	var sellada = false
	
	method sellar(){
		sellada = true
	}

	method sellada() = sellada

	override method recibirAmenaza(){
		velocidad = 0
	}

	override method prepararExtra(){
		self.sellar()
	}
}

class NaveDePasajeros inherits Nave {
	var property alarma = false
	const cantidadDePasajeros = 0
	const cantidadDePersonal = 4
	const velocidadMaxima = 300000
	
	method tripulacion() = cantidadDePasajeros + cantidadDePersonal

	method velocidadMaximaLegal() = velocidadMaxima / self.tripulacion() - if (cantidadDePasajeros > 100) 200 else 0

	method estaEnPeligro() = velocidad > self.velocidadMaximaLegal() or alarma

	override method recibirAmenaza() {
		alarma = true
	}
}

class NaveDeCombate inherits Nave{
	var property modo = reposo
	const property mensajesEmitidos = []


	method emitirMensaje(mensaje) {
		mensajesEmitidos.add(mensaje)
	}
	
	method ultimoMensaje() = mensajesEmitidos.last()

	method estaInvisible() = velocidad < 10000 and modo.invisible()

	override method recibirAmenaza() {
		modo.recibirAmenaza(self)
	}

	override method prepararExtra(){
		modo.preparar(self)
	}
}

class Modo{
	method invisible()

	method pedirEmision(nave, mensaje){
		nave.emitirMensaje(mensaje)
	}

	//TEMPLATE METHOD
	method recibirAmenaza(nave){
		self.pedirEmision(nave, self.mensajeAmenaza())
	}
	
	method mensajeAmenaza()

	method preparar(nave){
		self.pedirEmision(nave, self.mensajeAlPreparar())
	}

	method mensajeAlPreparar()
}

object reposo inherits Modo{
	const modoAlPreparar = ataque

	override method invisible() = false

	override method mensajeAmenaza() = "¡RETIRADA!"
	
	override method mensajeAlPreparar() = "Saliendo en misión"

	override method preparar(nave){
		super(nave) //Hacé lo que ya hacía con la misma nave.
		nave.modo(modoAlPreparar) //Pero además cambia al modo que yo se cual es.
	}	      
}

object ataque inherits Modo {
	override method invisible() = true

	override method mensajeAmenaza() = "Enemigo encontrado"
	
	override method mensajeAlPreparar() = "Volviendo a la base"

}
