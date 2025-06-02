import ezdxf
import json
import sys

def convert_dwg_to_json(input_file, output_file):
    try:
        dwg = ezdxf.readfile(input_file)

        data = {
            "layers": [],
            "entities": []
        }

        for layer in dwg.layers:
            layer_data = {
                "name": layer.dxf.name,
                "color": layer.dxf.color
            }
            data["layers"].append(layer_data)

        for entity in dwg.modelspace():
            if entity.dxftype() == "LINE":
                line_entity = {
                    "type": "LINE",
                    "start": [entity.dxf.start.x, entity.dxf.start.y, entity.dxf.start.z],
                    "end": [entity.dxf.end.x, entity.dxf.end.y, entity.dxf.end.z],
                    "layer": entity.dxf.layer
                }
                data["entities"].append(line_entity)

            elif entity.dxftype() == "CIRCLE":
                circle_entity = {
                    "type": "CIRCLE",
                    "center": [entity.dxf.center.x, entity.dxf.center.y, entity.dxf.center.z],
                    "radius": entity.dxf.radius,
                    "layer": entity.dxf.layer
                }
                data["entities"].append(circle_entity)

        with open(output_file, "w") as f:
            json.dump(data, f, indent=4)

        print("Conversion successful!")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    convert_dwg_to_json(input_file, output_file)

