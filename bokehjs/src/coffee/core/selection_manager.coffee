import {HasProps} from "./has_props"
import {Selector} from "./selector"
import * as hittest from "./hittest"
import * as p from "./properties"

export class SelectionManager extends HasProps
  type: 'SelectionManager'

  @internal {
    source: [ p.Any ]
  }

  initialize: (attrs, options) ->
    super(attrs, options)
    @selector = new Selector()
    @inspectors = {}

  select: (renderer_views, geometry, final, append=false) ->
    did_hit = false
    for r in renderer_views
      did_hit ||= r.hit_test(geometry, final, append)
    @source.select.emit()
    return did_hit

  inspect: (renderer_view, geometry) ->
    did_hit = false
    @_set_inspector(renderer_view.model)
    did_hit ||= renderer_view.hit_test(geometry, false, false, "inspect")
    @source.inspect.emit([renderer_view, {"geometry": geometry}])
    return did_hit

  clear: (rview) ->
    @selector.clear()
    @source.selected = hittest.create_hit_test_result()

  _set_inspector: (rmodel) ->
    id = rmodel.id
    if not @inspectors[id]?
      @inspectors[id] = new Selector()
