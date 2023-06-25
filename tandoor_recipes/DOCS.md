## Configuration

### Debug mode
0 is normal mode  
1 is debug mode.

### Authentication
using external authentication - not implemented yet.

### Gunicorn Media
Disabling gunicorn media is a good idea, but needs a webserver running to host the media files. The webserver should map `/media/`.  
See https://docs.tandoor.dev/install/docker/#nginx-vs-gunicorn for more information on this.  
0 is gunicorn DISABLED - media won't work without an nginx webserver.  
1 is gunicorn enabled - mesia will be hosted using gunicorn which is not recommended.

### External Recipe files

The directory `/config/addons_config/tandoor_recipes/externalfiles` can be used for importing external files in to Tandoor. You can map this with /opt/recipes/externalfiles within Docker. As per directions here: https://docs.tandoor.dev/features/external_recipes/
The directories `/config`, `/media/`, and `/share/` are mapped in to the addon. you can create a folder manually in any of these locations and map it in to tandoor:
- create a directory in the location you want, e.g. `/share/tandoor/specificrecipebook/`
- create an externalstorage location in tandoor - `/share/tandoor/`
- watch the specific folder - `/share/tandoor/specificrecipebook/`
- sync now
- import.
