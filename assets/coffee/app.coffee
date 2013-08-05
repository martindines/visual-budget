Expense = (title, value, vm) ->
  value = 0  if isNaN(value)
  @title = title
  @value = ko.observable(value)
  @total = @value() + vm.budgetRemaining()

ViewModel = ->
  self = this
  self.expenses = ko.observableArray([])
  self.budget = ko.observable(100)
  self.budgetRemaining = ko.computed(->
    total = self.budget()
    i = 0

    while i < self.expenses().length
      total -= self.expenses()[i].value()
      i++
    total
  , self)
  self.expenses.push new Expense("Insurance", 50, self)
  self.expenses.push new Expense("Rent", 30, self)
  self.addExpense = (form) ->
    self.expenses.push new Expense(form.title.value)

  self.removeExpense = (expense) ->
    self.expenses.remove expense
    
ko.bindingHandlers.slider =
  init: (element, valueAccessor, allBindingsAccessor) ->
    console.log "hit"
    options = allBindingsAccessor().sliderOptions or {}
    $(element).slider options
    ko.utils.registerEventHandler element, "slidechange", (event, ui) ->
      observable = valueAccessor()
      observable ui.value

    ko.utils.domNodeDisposal.addDisposeCallback element, ->
      $(element).slider "destroy"

    ko.utils.registerEventHandler element, "slide", (event, ui) ->
      observable = valueAccessor()
      observable ui.value

  update: (element, valueAccessor) ->
    console.log "update"
    value = ko.utils.unwrapObservable(valueAccessor())
    value = 0  if isNaN(value)
    $(element).slider "value", value

ko.applyBindings new ViewModel()