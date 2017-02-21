unit DinamicList;

const
	NULO = NIL;

type
	tnIngredient=string;
	tQuantity=integer;
	tGluten=boolean;
	tMilk=boolean;
	tAllergens= record
		gluten:tGluten;
		milk:tMilk;
		end;

	tItem= record
		nIngredient:tnIngredient;
		quantity:tQuantity;
		allergens:tAllergens;
		end;
	
	tPosL= ^tNodo;

	
	tNodo = record
		item:tItem;
		next:tPosL;
	end;
	tList = tPosL;
	
BEGIN
	
	
END.

