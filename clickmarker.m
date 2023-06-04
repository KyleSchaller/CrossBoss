function clickmarker(src,ev)
set(ancestor(src,'figure'),'windowbuttonmotionfcn',{@dragmarker,src})
set(ancestor(src,'figure'),'windowbuttonupfcn',@stopdragging)