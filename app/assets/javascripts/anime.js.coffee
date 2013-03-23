$ ->
  $("form.autosubmit select").change ->
    $("form.autosubmit").submit();
