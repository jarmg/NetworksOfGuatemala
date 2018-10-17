# Utilities used across analyses - DRY
library(dplyr)


Int2Factor <- function(x) {
    if(!is.null(attr(x, "value.labels"))){
        vlab <- attr(x, "value.labels")
        if(sum(duplicated(vlab)) > 0)
            cat("Duplicated levels:", vlab, "\n")
        else if(sum(duplicated(names(vlab))) > 0)
            cat("Duplicated labels:",
                names(vlab)[duplicated(names(vlab))], "\n")
        else
            x <- factor(x, levels = as.numeric(vlab),
                        labels = names(vlab))
    }
    x
}

###############################
####### String cleaning #######
###############################
accentMap = list(  'Š'='S', 'š'='s', 'Ž'='Z', 'ž'='z', 'À'='A',    
                        'Á'='A', 'Â'='A', 'Ã'='A', 'Ä'='A', 'Å'='A',    
                        'Æ'='A', 'Ç'='C', 'È'='E', 'É'='E', 'Ê'='E',    
                        'Ë'='E', 'Ì'='I', 'Í'='I', 'Î'='I', 'Ï'='I',    
                        'Ñ'='N', 'Ò'='O', 'Ó'='O', 'Ô'='O', 'Õ'='O',    
                        'Ö'='O', 'Ø'='O', 'Ù'='U', 'Ú'='U', 'Û'='U',    
                        'Ü'='U', 'Ý'='Y', 'Þ'='B', 'ß'='Ss', 'à'='a',   
                        'á'='a', 'â'='a', 'ã'='a', 'ä'='a', 'å'='a',    
                        'æ'='a', 'ç'='c', 'è'='e', 'é'='e', 'ê'='e',    
                        'ë'='e', 'ì'='i', 'í'='i', 'î'='i', 'ï'='i',    
                        'ð'='o', 'ñ'='n', 'ò'='o', 'ó'='o', 'ô'='o',    
                        'õ'='o', 'ö'='o', 'ø'='o', 'ù'='u', 'ú'='u',    
                        'û'='u', 'ý'='y', 'ý'='y', 'þ'='b', 'ÿ'='y' )  

RemoveAccents  <- function(strings) {    
  chartr(paste(names(accentMap), collapse=''),    
         paste(accentMap, collapse=''), strings)    
}

CleanString <- function(string) {
  RemoveAccents(string) %>% tolower
}
