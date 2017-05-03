{
TITLE: PROGRAMMING II LABS  
SUBTITLE: Practical 1
AUTHOR 1: Julián Penedo Carrodeguas LOGIN 1: j.pcarrodeguas
AUTHOR 2: Pablo Ramos Muras LOGIN 2: pablo.muras 
GROUP: 4.2  
DATE: 14/03/2017
}

program main;

	
	uses StaticList,crt,sysutils;

////////////////////////////////Funciones Internas//////////////////////	
	
	function IntToStr(int:integer):string;
	begin
		Str(int,IntToStr);  (*Transforma un integer directamente a String.*)
	end;
	
	function boolToString(bool:boolean):string;
	begin
		if(bool)
			then boolToString := 'true'
			else boolToString := 'false'; (*Transforma un boolean en un string*)
			
	end;
	
	procedure imprimirItem(item:tItem);
	begin
		writeln('* Ingredient ',item.nIngredient,': ',item.quantity); (*Procedimiento que imprime un item determinado, usado en allergens y en stock*)
		if(item.allergens.gluten)
		then writeln('      Contains gluten');
		
		if(item.allergens.milk)
		then writeln('      Contains milk');
	end;
	
	procedure imprimirLinea(linea1:string;linea2:string;linea3:string;linea4:string;linea5:string);
	begin
		writeln('**** ',linea1,' ',linea2,' ',linea3,' ',linea4,' ',linea5);
	end;
	
	procedure imprimirError(error1:string;error2:string;error3:string); (*Dos funciones encargadas de imprimir lineas con el formato correcto*)
	begin
		writeln('++++ ',error1,' ',error2,' ',error3);
	end;
	
	procedure DeleteList(var L:tList);
	begin
		while NOT isEmptyList(L) do
			deleteAtPosition(last(L),L);
	end;
////////////////////////////////////////////////////////////////////////
		
	procedure newIngredient(nIngrediente:tnIngredient;cant:tQuantity;gluten:tGluten;milk:tMilk;var lista:tList);
	(*Entradas: nIngrediente, cant, gluten, milk, lista.
	Salida: La lista modificada con el nuevo ingrediente añadido.
	Objetivo: Añadir un nuevo ingrediente a la lista
	PostCD: Que la lista este inicializada
	*)
	var
		item:tItem; //Item a insertar
		sCant:string; //Cantidad en string para imprimir más comodo
	begin
		Str(cant,sCant);
		imprimirLinea('Adding new ingredient:',nIngrediente,sCant,boolToString(gluten),boolToString(milk));
		if(cant<=0)
			then imprimirError('Error adding New:','Invalid','Quantity')
			else begin
				if(findItem(nIngrediente,lista)<>NULL)
					then imprimirError('ERROR Adding New: Ingredient',nIngrediente,'already exists')
					else begin
						item.nIngredient := nIngrediente;
						item.quantity := cant;
						item.allergens.gluten := gluten;
						item.allergens.milk := milk;
						if NOT(insertItem(item,NULL,lista))
							then imprimirLinea('WARNING: Out of memory','for','adding',nIngrediente,'ingredient');					
					end;
			end;	
	end;
	
	procedure Modify(nIngredient:tnIngredient;quantity:tQuantity;var list:tList);
	(*Entradas: nIngredient, quantity, lista.
	Salida: La lista modificada con la cantidad del ingrediente modificada.
	Objetivo: Modificar la cantidad de un ingrediente ya incluido en la lista 
	PostCD: Que la lista este inicializada
	*)
	var
		pos:tPosL; //posición del elemento
		item:tItem;//item donde volcar los datos.
	begin
		if(quantity=0) then
			imprimirError('ERROR','Modifying:','invalid quantity') (*Caso cantidad = 0*)
		else begin
			pos:=findItem(nIngredient,list);
			if(pos=NULL) then
				imprimirError('ERROR Modifying: ingredient',nIngredient,'does not exist') (*Caso en el que no existe el ingrediente a modificar*)
			else begin
				item := getItem(pos,list);
				item.quantity:=item.quantity+quantity;
				if(item.quantity=0) then begin
					imprimirLinea('Ingredient',nIngredient,'run out','of','stock'); (*El ingrediente se queda a 0, es eliminado.*)
					deleteAtPosition(pos,List);
				end
				else if(item.quantity>0) then begin	
					updateItem(list,pos,item);
					imprimirLinea('New','quantity for ingredient',nIngredient,':',IntToStr(quantity)); (*El ingrediente es modificado normal*)
				end
				else
					imprimirError('ERROR Modifying:','not enough','quantity');(*El ingrediente no tiene suficiente cantidad para ser modificado*)
			end;
		end;
	end;
	
	procedure Remove(Quantity:tQuantity;var list:tList);
	(*Entradas: Quantity, lista.
	Salida: La lista modificada con los ingredientes afectados eliminados.
	Objetivo: Eliminar todo ingrediente de la lista con una cantidad menor a la especificada
	PostCD: Que la lista este inicializada
	*)
	var
		pos:tPosL; //posición que recorre la lista
		item:tItem;//item donde se vuelcan los datos
		cont:integer=0;//contador de eliminados
	begin
		imprimirLinea('Removing' ,'ingredients', 'with', 'quantity inferior to',IntToStr(Quantity));
		if(isEmptyList(list)) then
			imprimirLinea('No','ingredients','found' ,'in' ,'stock')
		else begin
			pos:=first(list);
			while(pos<>NULL) do begin
				item:=getItem(pos,list);
				if(item.quantity<Quantity) then begin
					writeln('* Ingredient ',item.nIngredient,': ',IntToStr(item.quantity));
					deleteAtPosition(pos,list);
					cont:=cont+1;
				end;
				pos:=next(pos,list);
			end;
			if(cont=0) then
				imprimirLinea('No','ingredients','found' ,'in' ,'stock')
			else
				imprimirLinea('Number','of','ingredients','removed:',IntToStr(cont));
		end;		
	end;
	
	procedure Allergens(gluten:boolean;milk:boolean;Lista:tList);
	(*Entradas: gluten, milk, lista.
	Objetivo: Imprimir por pantalla el los ingredientes que contengan los alergenos especificados
	PostCD: Que la lista este inicializada
	*)
	var
		p:tPosL; //posicion que recorre la lista
		i:tItem; //item donde se vuelcan los atos
		exist:boolean; //Existen ingredientes con allergens
	begin
	if isEmptyList(Lista)then
			imprimirLinea('No','stock','available','','')
	else begin
		p:=first(Lista);
		exist:=false;
		if gluten then  
			if milk then begin																		(*Gluten & Milk*)
				while p <> NULL do begin
					i:=getItem(p,Lista);
					if (i.allergens.gluten) OR (i.allergens.milk) then begin
						if NOT exist then begin
							imprimirLinea('Ingredients','with','allergens:','','');
							exist:=true;
						end;
						imprimirItem(i);
					end;
					p:=next(p,lista);
				end;
				if NOT exist then
					imprimirLinea('Current','stock','completely','allergen-free','');
				end
				else begin																		(*Gluten & NOT Milk*)
					while p <> NULL do begin
						i:=getItem(p,Lista);
						if i.allergens.gluten then begin
							if NOT exist then begin
								imprimirLinea('Ingredients','with','gluten:','','');
								exist:=true;
							end;
							writeln('* Ingredient ',i.nIngredient,': ',i.quantity);
						end;
						p:=next(p,lista);
	
					end;
					if NOT exist then
						imprimirLinea('Current','stock','completely','allergen-free','');
				end
			else									
				if milk then begin																		(*NOT Gluten & Milk*)
					while p <> NULL do begin
						i:=getItem(p,Lista);
						if i.allergens.milk then begin
							if NOT exist then begin
								imprimirLinea('Ingredients','with','milk:','','');
								exist:=true;
							end;
							writeln('* Ingredient ',i.nIngredient,': ',i.quantity);
						end;	
						p:=next(p,lista);
					end;
					if NOT exist then
						imprimirLinea('Current','stock','completely','allergen-free','');
				end
			else begin
				imprimirError('ERROR','Showing allergens:','allergen not determined');		(*NOT Gluten & NOT Milk*)
			end;
		end;
	end;
	
	procedure Stock(withQuantity:boolean;Quantity:integer;lista:tList);
	(*Entradas: withQuantity, Quantity, lista.
	Objetivo: Mostrar todos los ingredientes que estan actualmente en la lista, si se especifica una cantidad, muestra solo aquellos por debajo de esta cantidad.
	PostCD: Que la lista este inicializada*)
	var
		q:tPosL;
		item:tItem;
		printed:boolean;
		gluten,milk,total:integer;
		pgluten,pmilk:real;
	begin
		gluten :=0; milk:=0; total:=0; pgluten := 0; pmilk := 0;
		if(Quantity<=0)
		then imprimirError('ERROR in Stock:','invalid','quantity')
		else begin
		
			if (isEmptyList(lista))
			then
				imprimirLinea('No','stock','available',' ',' ')
			else begin
				q:=last(lista);
				if(withQuantity)
				then begin
					imprimirLinea('Stock(<',IntToStr(Quantity),'):',' ',' ');
					while(q<>NULL) do begin
						item:=getItem(q,lista);
						if(item.quantity<Quantity)
						then begin
							printed:=true;                      (*Caso con cantidad mínima.*)
							imprimirItem(item);
							total:=total+1;
						if(item.allergens.gluten)
							then gluten:=gluten+1;
						if(item.allergens.milk)
							then milk:=milk+1;
						end;
						q:=previous(q,lista);
						end;
				end			
				else begin
					imprimirLinea('Stock',':',' ',' ',' ');
					while(q<>NULL) do begin
						item:=getItem(q,lista);
						imprimirItem(item);
						total:=total+1;
						if(item.allergens.gluten)
							then gluten:=gluten+1;               (*Caso sin cantidad minima*)
						if(item.allergens.milk)
							then milk:=milk+1;
						q:=previous(q,lista);
					end;
				end;
			
			if(withQuantity)AND(NOT(printed))
				then imprimirLinea('No','ingredients','below','the','threshold');
	
			if(printed)
				then begin
					if(withQuantity)
						then imprimirLinea('Number of ingredients','in stock (<',IntToStr(Quantity),'):',IntToStr(total))
						else imprimirLinea('Number of ingredients','in','stock',':',IntToStr(total));
					pgluten:=(gluten/total)*100;
					pmilk:=(milk/total)*100;
					writeln('      ',pgluten:0:1,'% contains gluten');
					writeln('      ',pmilk:0:1,'% contains milk');
				end;
			end;
		end;
	end;
	
	
	procedure readTasks(taskFile:string);
	var
	   fileId:Text; //file identifier
	   code: string; //code for each task[N, M, R, S or A]
	   line:string; //each line in the file
	   name:string; //name of ingredient
	   quantity:integer; //quantity of the ingredient
	   allergen1: string; // string "true" or "false" to indicate if the ingredient contains gluten
	   allergen2: string; // string "true" or "false"to indicate if the ingredient contains milk
	   strquantity:string; //string to convert to quantity
	   withQuantity: boolean; //indicates the operation S includes a quantity
	   gluten: boolean; //indicates if the ingredient has gluten
	   milk: boolean;//indicates if the ingredient has milk
	   lista:tList;
	   //ADD VARIABLES IF YOU NEED THEM
	   	
		
	begin
	   createEmptyList(lista);
	   {$i-}
	   assign(fileId, taskFile);
	   reset(fileId);
	   {$i+}
	   if (IOResult<>0) then begin
	   		writeln('**** Reading. Error when trying to open ', taskFile);
	   		halt(1);
	   end;
	
	  //Read all lines in file
	   While (not EOF(fileId))  do
	   begin
	      readln(fileId, line);
	      code:=trim(copy(line,1,2));
	      writeln('*******************************************');
	     
	      //Select the proper arguments from each line of the file
	      case code[1] of
			'N', 'n': begin 
						name:=(trim(copy(line,3,12))); 
						val(trim(copy(line,17,7)),quantity);				
						allergen1:=trim(copy(line,23,6));
						allergen2:=trim(copy(line,29,6));
						writeln('Task ',code,': ',name,' ',quantity,' ',allergen1,' ',allergen2);
						writeln('*******************************************');
						//converts a string (true/false) to boolean
						if not TryStrToBool(allergen1, gluten) then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end; 
						if not TryStrToBool(allergen2, milk)then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end; 
						newIngredient(name,quantity,gluten,milk,lista);
					  end;
			'M', 'm': begin 
						name:=trim(copy(line,3,12)); 
						val(trim(copy(line,17,7)),quantity);
						writeln('Task ',code,': ',name,' ',quantity);
						writeln('*******************************************');
						Modify(name,quantity,lista);
					  end;
			'R', 'r': begin
						val(trim(copy(line,3,7)),quantity);
						writeln('Task ',code,': ',quantity);
						writeln('*******************************************');
						Remove(quantity,lista);
					  end;
			'A', 'a': begin 
						allergen1:=trim(copy(line,3,6));
						allergen2:=trim(copy(line,9,6));
						writeln('Task ',code,': ',allergen1,' ',allergen2);
						writeln('*******************************************');
											//converts a string (true/false) to boolean
						if not TryStrToBool(allergen1, gluten) then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end; 
						if not TryStrToBool(allergen2, milk)then begin
							writeln('**** Reading. Error reading data from ', taskFile);
							halt(1);
						end;
						Allergens(gluten,milk,lista);  
					  end;
			'S', 's': begin 
						strquantity:=trim(copy(line,3,7));
						writeln('Task ',code,': ',strquantity);
						writeln('*******************************************');
						if (strquantity <>'') then begin
							val(strquantity,quantity);
							withQuantity:=true;
						end
						else withQuantity:=false;
						Stock(withQuantity,quantity,lista);
					  end;
		end;
		
		DeleteList(lista);
		
		end; (*while*)
	
	end; 
	
	
	// ---------------------------------------------------------------------------------
	
	BEGIN
	
		if (paramCount>0) then
			readTasks(ParamStr(1))
		else
			readTasks('Allergens.txt');
	

END.
