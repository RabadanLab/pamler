#!/bin/bash

PROTEIN="$1"
FASTA="${PROTEIN}.fa"
TREE="${PROTEIN}.tree"
MODEL="${PROTEIN}_fit"
RESULT="${PROTEIN}_model"

cat << OUTPUT
inputRedirect = {};
inputRedirect["01"] = "Universal";
inputRedirect["02"] = "New Analysis";
inputRedirect["03"] = "Default";
inputRedirect["04"] = "1";
inputRedirect["05"] = "/home/parkk93/Columbia/GSAS/Research/17_S/QUEST/${FASTA}";
inputRedirect["06"] = "/home/parkk93/Columbia/GSAS/Research/17_S/QUEST/${TREE}";
inputRedirect["07"] = "/home/parkk93/Columbia/GSAS/Research/17_S/QUEST/${MODEL}";
inputRedirect["08"] = "Neutral";
inputRedirect["09"] = "FEL";
inputRedirect["10"] = "-0.05";
inputRedirect["11"] = "0.1";
inputRedirect["12"] = "All";
inputRedirect["13"] = "/home/parkk93/Columbia/GSAS/Research/17_S/QUEST/${RESULT}";
ExecuteAFile (HYPHY_BASE_DIRECTORY + "res" + DIRECTORY_SEPARATOR + "TemplateBatchFiles" + DIRECTORY_SEPARATOR + "QuickSelectionDetectionMF.bf", inputRedirect);
OUTPUT
