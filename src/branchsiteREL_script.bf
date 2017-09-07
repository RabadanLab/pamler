fileToExe = "/home/juan/Desktop/hyphy/res/TemplateBatchFiles/BranchSiteREL.bf";
SetDialogPrompt ( "Provide a list of FASTA files to process:" );
fscanf ( PROMPT_FOR_FILE, "Lines", _inDirectoryPaths );
fprintf (stdout, "[READ ", Columns (_inDirectoryPaths), " file path lines]\n");
SetDialogPrompt ( "Provide a list of TREE files to process:" );
fscanf ( PROMPT_FOR_FILE, "Lines", _inDirectoryPaths2 );
fprintf (stdout, "[READ ", Columns (_inDirectoryPaths2), " file path lines]\n");
inputRedirect = {};
inputRedirect["01"] = "Universal";
inputRedirect["02"] = "Yes";
inputRedirect["03"] = "No";
inputRedirect["06"] = "All";
inputRedirect["07"] = "";
for ( _fileLine = 0; _fileLine < Columns ( _inDirectoryPaths ); _fileLine = _fileLine + 1 ) {
	fprintf (stdout, _inDirectoryPaths[ _fileLine ]);
	inputRedirect [ "04" ]	= _inDirectoryPaths[ _fileLine ];
	inputRedirect [ "05" ]	= _inDirectoryPaths2[ _fileLine ];
	ExecuteAFile ( fileToExe, inputRedirect );

}

