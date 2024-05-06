listOfOptionNames:
let 
	optionNameToAttrSetToPreprocess = optionName: { name = optionName; value = { enable = true; }; }; 
in
builtins.listToAttrs (map (x: optionNameToAttrSetToPreprocess x) listOfOptionNames)
