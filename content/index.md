---
title: Home
---

<%
post = @items.find { |i| i.identifier.to_s == '/posts/2020-12-23-test/' }
%>

<%= post.reps[:excerpt].compiled_content(:snapshot => :excerpt) %>
