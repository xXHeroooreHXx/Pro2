unit DinamicList;
interface
const
	NULL = NIL;

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
	
procedure createEmptyList(VAR L:tList);
function isEmptyList(L:tList):boolean;
function first(L:tList):tPosL;
function last(L:tList):tPosL;
function next(p:tPosL; L:tList):tPosL;
function previous(p:tPosL; L:tList):tPosL;
//function insertItem(i:tItem; p:tPosL; L:tList):boolean;
//procedure deleteAtPosition (p:tPosL; VAR L:tList);
function getItem (p:tPosL; L:tList):tItem;
procedure updateItem (VAR L:tList; p:tPosL; i:tItem);
function findItem (ing:tnIngredient; L:tList):tPosL;



implementation	

procedure createEmptyList(var l:tList);
begin
	l:=NULL;
end;

function isEmptyList(l:tList):boolean;
begin
	isEmptyList:=(l=NULL)
end;

function first(l:tList):tPosL;
begin
	first:=l;
end;

function last(l:tList):tPosL;
var
p:tPosL;
begin
	p:=first(l);
	while(p^.next <> NULL) do
		p:=p^.next;
	last:=p;
end;

function next(p:tPosL; L:tList):tPosL;
begin
	next:=p^.next;
end;

function previous(p:tPosL; l:tList):tPosL;
var
	q:tPosL;
begin
	if(p=l) then
		previous:=NULL
	else begin
		q:=first(l);
		while(q^.next <> p) do
			q:=q^.next;
		previous := q;
	end;
end;

function getItem(p:tPosL; L:tList): tItem;
begin
	getItem:=p^.item;
end;

procedure updateItem(var l:tList;p:tPosL;i:tItem);
begin
	p^.item:=i;
end;

function findItem (ing:tnIngredient; L:tList):tPosL;
begin
	if(l^.item.nIngredient = ing) then
		findItem := l
	else
		findItem(ing,l^.next);
end;
BEGIN
	
	
END.

