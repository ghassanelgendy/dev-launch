import yaml
import json
import sys
import os
from jsonschema import validate, ValidationError

def validate_config(config_path, schema_path):
    if not os.path.exists(config_path):
        print(f"ERROR: Config file {config_path} not found.")
        sys.exit(1)
    
    with open(config_path, 'r') as f:
        try:
            config = yaml.safe_load(f)
        except yaml.YAMLError as e:
            print(f"ERROR: Failed to parse YAML: {e}")
            sys.exit(1)
            
    with open(schema_path, 'r') as f:
        schema = json.load(f)
        
    try:
        validate(instance=config, schema=schema)
        print(f"SUCCESS: {config_path} is valid.")
    except ValidationError as e:
        print(f"ERROR: Validation failed for {config_path}")
        print(f"Path: {'.'.join(str(v) for v in e.path)}")
        print(f"Message: {e.message}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python validate.py <path_to_app_yaml>")
        sys.exit(1)
        
    app_config = sys.argv[1]
    schema_file = os.path.join(os.path.dirname(__file__), "schemas", "app-config.schema.json")
    validate_config(app_config, schema_file)
