using Gtk

man = ["""
  _____
  |   |
      |
      |
      |
      |
_________""", """
  _____
  |   |
  O   |
      |
      |
      |
_________""", """
  _____
  |   |
  O   |
  |   |
      |
      |
_________""", """
  _____
  |   |
  O   |
 /|   |
      |
      |
_________""", """
  _____
  |   |
  O   |
 /|\\  |
      |
      |
_________""", """
  _____
  |   |
  O   |
 /|\\  |
 /    |
      |
_________""", """
  _____
  |   |
  O   |
 /|\\  |
 / \\  |
      |
_________"""]



function enterword(w)
    global ans = uppercase(get_gtk_property(wordin, :text, String))
    destroy(vbox)
    game()
end

# Get word to be guessed from the user
global win = GtkWindow("Window", 400, 300)

vbox = GtkBox(:v)

wordin = GtkEntry()
set_gtk_property!(wordin, :text, "word here")
enter = GtkButton("Enter")
signal_connect(enterword, enter, "clicked")

push!(vbox, wordin)
push!(vbox, enter)
push!(win, vbox)

showall(win)


function clicked(w)
    letter = get_gtk_property(w, :label, String)

    if occursin(letter, ans)
        indexes = findall(x->x==collect(letter)[1],collect(ans))

        for i in indexes
            line[i] = ans[i]
        end

        println(line)

        displaylinetext = ""
        for i in line
            displaylinetext *= i
        end
        GAccessor.text(displayline, displaylinetext)
        showall(win)

        if !(occursin("_",displaylinetext))
            destroy(g)
            won = GtkLabel("YOU WON")
            push!(hbox, won)
            showall(win)
        end
    else
        global wrong += 1
        GAccessor.text(hangman, man[wrong])

        if wrong >= 7
            destroy(g)
            GAccessor.text(displayline, ans)
            lost = GtkLabel("YOU LOST")
            push!(hbox, lost)
            showall(win)
        end
    end
    destroy(w)

end

function game()
    global wrong = 1
    global vbox = GtkBox(:v)
    global hbox = GtkBox(:h)
    set_gtk_property!(hbox, :margin, 100)
    set_gtk_property!(hbox, :margin_left, 60)
    set_gtk_property!(hbox, :spacing, 100)

    global line = []

    for i in 1:length(ans)
        if ans[i] != ' '
            line = vcat(line, " _ ")
        else
            line = vcat(line, "   ")
        end
    end

    for i in line
        print(i)
    end

    displaylinetext = ""
    for i in line
        displaylinetext *= i
    end

    global displayline = GtkLabel(displaylinetext)

    global g = GtkGrid()
    alph = [GtkButton(string(Char(i))) for i in 65:90]
    for i in alph
        signal_connect(clicked, i, "clicked")
    end

    for i = 1:13
        g[i,1] = alph[i]
    end

    for i = 1:13
        g[i,2] = alph[i+13]
    end
    set_gtk_property!(g, :column_homogeneous, true)
    set_gtk_property!(g, :column_spacing, 15)

    global hangman = GtkLabel(man[1])

    push!(hbox, displayline)
    push!(hbox, hangman)
    push!(vbox, hbox)
    push!(vbox, g)
    push!(win, vbox)
    showall(win)
end
