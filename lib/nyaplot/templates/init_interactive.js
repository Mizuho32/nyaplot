(function(){
    if(window.IPython !== undefined){
        var comm_global = null;

        var callback = function(uuid, ranges){
            comm_global.send("selected", {
                uuid: uuid,
                range: ranges.x
            });
        };

        window.Nyaplot.sheet_manager.register_sheet(
            "interactive_layer",
            ["scalex", "scaley", "uuid"],
            {
                opacity: 0.125,
                color: 'gray'
            },
            function(parent, scalex, scaley, uuid, options){
                console("nya0");

                var brushed = function(){
                    var ranges = {
                        x: (brush.empty() ? scalex.domain() : brush.extent()),
                        y: scaley.domain()
                    };
                    callback(uuid, ranges);
                };

                var brush = d3.svg.brush()
                        .x(scalex)
                        .on("brushend", brushed);

                console("nya1");

                var model = parent.append("g");
                var height = d3.max(scaley.range()) - d3.min(scaley.range());
                var y = d3.min(scaley.range());

                console("nya");

                parent.call(brush)
                    .selectAll("rect")
                    .attr("y", y)
                    .attr("height", height)
                    .style({
                        "fill-opacity": options.opacity,
                        "fill": options.color,
                        "shape-rendering": "crispEdges"
                    });
            }
        );

        window.IPython.notebook.kernel.comm_manager.register_target("nyaplot_interactive", function(comm, msg){
            comm.on_msg(function(msg_){
                console.log("msg has come. ", msg_);
                var msg = msg_.content.data;

                switch(msg.type){
                case "hello":
                    comm_global = comm;
                    break;
                case "update":
                    /*
                     msg: {
                     type: "update",
                     model: model
                     }
                     */
                    console.log("update");
                    window.Nyaplot.core.parse(msg.model);
                    break;
                default:
                    console.log("error", msg);
                    break;
                }
            });
        });
    }
})();
