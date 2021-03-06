$ ->
  # Go the the new task for company page on click.
  $(document).on 'click', '.new_task_on_company', (e) ->
    company_id = $("#customer option:selected").val()
    this.href = "/customers/#{company_id}/tasks/new"

  # SELECT SMS to customer
  $(document).on 'click', '.msg_to_customer', (e) ->
    e.preventDefault()
    $('#msg_form').show()

  $(document).on 'click', '.send_msg', (e) ->
    e.preventDefault()
    alert('Melding sendt til kunden')

  # Show employees belong to the selected department
  $(document).on 'change', '#task_department_id', (e) ->
    id = $("#task_department_id option:selected").val()
    $('.title').show()
    $('.employees').hide()
    $("#department_#{id}").show()


  $(document).on 'click', '[data-select]', (e) ->
    inventory_id = $('[data-select]').closest('[data-id]').data('id')
    url = $('[data-select]').closest('[data-url]').data('url')
