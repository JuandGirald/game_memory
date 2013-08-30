#variables globales para el juego
iTiempoTranscurrido = iPuntosObtenidos = 0
iTiempoLimite = 300
objPrimero = undefined
blnJuegoFinalizado = false
parejas = 0
clicks = 0

$(document).ready ->	
	
	$("p1").hide()
	#establecer la cantidad de figuras distintas que tenemos
	#y cuantas veces debemos iterar para dibujar la cuadricula correctamente
	strCuadros = [1, 2, 3, 4, 5, 6]
	iRepeticiones = 4

	$("ul").delegate "li", 'click', ->
	  if not blnJuegoFinalizado and $(this).css("opacity") > 0
	    strImagen = "assets/" + $(this).attr("rel") + ".jpg"
	    if objPrimero is `undefined`
	      objPrimero = $(this)
	      objPrimero.stop(true, true).animate(opacity: .9).css "background-image", "url(" + strImagen + ")"
	    else
	      objSegundo = $(this)
	      objSegundo.stop(true, true).animate(opacity: .9).css "background-image", "url(" + strImagen + ")"
	      
	      #nos aseguramos que no se este clickeando sobre el mismo elemento
	      unless objPrimero.index() is objSegundo.index()
	        
	        #el usuario encontro una pareja (los dos elementos coinciden)
	        if objPrimero.attr("rel") is objSegundo.attr("rel")
	          
	          #aumentamos los puntos en 1
	          iPuntosObtenidos++
	          parejas++
	          clicks++

	          #ocultamos la pareja para que no aparezca mas
	          $(objPrimero).stop(true, true).animate(opacity: 1).delay(700).animate opacity: 0
	          $(objSegundo).stop(true, true).animate(opacity: 1).delay(700).animate opacity: 0
	          
	          #finalizamos el juego porque ya encontro todas las parejas
	          if parejas is 12
	          	alert("Good Job, you win!")
	          	$.fntFinalizarJuego()  
	        
	        else
	          
	          #Se decrementa despues del primer click
	          
	          iPuntosObtenidos-- if clicks > 0

	          #el usuario no encontro una pareja, no coinciden los elementos	          
	          #borramos el contenido de los elementos seleccionados por el usuario        


	          $(objPrimero).stop(true, true).animate
	            opacity: 1
	          , 1000, ->
	            $(this).css "background-image", "none"

	          $(objSegundo).stop(true, true).animate
	            opacity: 1
	          , 1000, ->
	            $(this).css "background-image", "none"

	          clicks++

	          

	          #finalizamos el juego si no tiene puntos
	          if iPuntosObtenidos is 0
	          	alert("Game Over - Try Again")
	          	$.fntFinalizarJuego() 


	      else
	        
	        #se esta clickeando sobre el mismo elemento, entonces le devolvemos su opacidad original
	        $(this).stop(true, true).animate
	          opacity: 1
	        , 1000, ->
	          $(this).html "&nbsp;"

	      
	      #limpiamos la variable que contiene al primer elemento
	      objPrimero = `undefined`
	  else
		#el juego finalizo o el elemento clickeado ya fue descubierto

	
	$.fntTiempo = ->
	  unless blnJuegoFinalizado
	    if iTiempoTranscurrido >= iTiempoLimite
	      
	      #finalizar el juego por tiempo
	      $.fntFinalizarJuego()
	    else
	      
	      #volvemos a llamar a esta funcion un segundo despues
	      setTimeout "$.fntTiempo()", 1000
	      
	      #mostrar el estado del juego
	      $("#divContador").find("p").html "<strong>Puntos obtenidos: </strong>" + 
	      iPuntosObtenidos + " &bull; <strong>Tiempo restante: </strong>" + 
	      (iTiempoLimite - iTiempoTranscurrido) + " segundos";  
	      $("p1").fadeIn()
	      
	      #aumentamos el contador de tiempo transcurido
	      iTiempoTranscurrido++



	$.fntFinalizarJuego = ->
	  $("p1").hide()
	  $("#divContenedor ul").html ""
	  
	  #finalizar el juego
	  blnJuegoFinalizado = true
	  
	  #mostrar el estado final
	  $("#divContador").find("p").html "<strong>Puntos obtenidos: </strong>" + iPuntosObtenidos + " &bull; <strong>Tiempo empleado: 
	  </strong>" + iTiempoTranscurrido + " segundos"
	  
	  #mostramos la pagina inicial
	  $("#divInicio").stop(true, true).fadeIn 1500, ->
	    $("ul li").stop(true, true).css("opacity", 1).html "&nbsp;"

	$.fntIniciarJuego = ->
	  
	  #mostramos el estado del juego
	  $("#divContador").find("p").html "Cargando..."
	  
	  #creamos la cuadricula
	  iCont = 0

	  while iCont < iRepeticiones
	    
	    #desordenamos el array
	    strCuadros = strCuadros.sort(->
	      Math.random() - 0.5
	    )
	    
	    #agregamos los items a la lista (inicialmente vacios)
	    iCuadros = 0

	    while iCuadros < strCuadros.length
	      $("#divContenedor ul").append "<li rel=\"" + strCuadros[iCuadros] + "\">&nbsp;</li>"
	      iCuadros++
	    iCont++
	  
	  iPuntosObtenidos =  $("ul li").length / 2
	  #reseteamos todas las variables globales
	  iTiempoTranscurrido = 0
	  objPrimero = `undefined`

	  
	  #ocultamos la capa inicial
	  $("#divInicio").stop(true, true).fadeOut 1500, ->
	    
	    #iniciamos el conteo de tiempo
	    blnJuegoFinalizado = false
	    $.fntTiempo()



  #clic en el boton jugar
  $("#btnJugar").on "click", ->  
    #iniciamos el juego
    $.fntIniciarJuego()

  $("#btnCreditos").on "click", ->
  	$("#divCreditos").fadeToggle("slow")

  $("#btnReinicio").on "click", ->
  	#Reiniciar el Juego
  	$.fntFinalizarJuego()