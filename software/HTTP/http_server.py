import dash
import dash_core_components as dcc
import dash_html_components as html
import numpy as np

from SQL.sql_operations import Operations


class HTTP:

    def start(self):
        self.app.run_server(debug=False)

    def __init__(self,database_path, database_file):
        external_stylesheets = ['https://codepen.io/chriddyp/pen/bWLwgP.css']
        self.database_path, self.database_file = database_path,database_file

        self.app = dash.Dash(__name__, external_stylesheets=external_stylesheets)
        self.app.layout = self.get_layout

    def get_layout(self):
        op = Operations(self.database_path, self.database_file)
        y = np.asarray(op.load_data('value'))
        x = op.load_data('date_time')

        x = [element for tupl in x for element in tupl]
        y = [element for tupl in y for element in tupl]
        return html.Div(children=[
            dcc.Graph(
                id='example-graph',
                figure={
                    'data': [
                        {'x': x, 'y': y, 'type': 'line', 'name': 'temperature'},
                    ],
                    'layout': {
                        'title': 'ESP8266 temperature Celsius'
                    }
                }
            )
        ])
