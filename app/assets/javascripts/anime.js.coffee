$ ->
  $("form.autosubmit select.autosubmit").change ->
    $("form.autosubmit").submit();
