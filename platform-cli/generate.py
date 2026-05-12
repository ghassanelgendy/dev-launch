import yaml
import sys
import os
from jinja2 import Environment, FileSystemLoader

def generate_values(config_path, template_path, output_path):
    if not os.path.exists(config_path):
        print(f"ERROR: Config file {config_path} not found.")
        sys.exit(1)
        
    with open(config_path, 'r') as f:
        config = yaml.safe_load(f)
        
    env = Environment(loader=FileSystemLoader(os.path.dirname(template_path)))
    template = env.get_template(os.path.basename(template_path))
    
    output = template.render(**config)
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, 'w') as f:
        f.write(output)
    
    print(f"SUCCESS: Generated {output_path}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python generate.py <path_to_app_yaml> <output_path>")
        sys.exit(1)
        
    app_config = sys.argv[1]
    output_file = sys.argv[2]
    template_file = os.path.join(os.path.dirname(__file__), "templates", "values.yaml.j2")
    
    generate_values(app_config, template_file, output_file)
