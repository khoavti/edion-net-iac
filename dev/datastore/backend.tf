terraform { 
  cloud { 
    
    organization = "vti" 

    workspaces { 
      name = "edion-net-iac-datastore" 
    } 
  } 
}