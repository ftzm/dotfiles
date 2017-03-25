;;; xpm-autoloads.el --- automatically extracted autoloads
;;
;;; Code:
(add-to-list 'load-path (directory-file-name (or (file-name-directory #$) (car load-path))))

;;;### (autoloads nil "xpm" "xpm.el" (22732 17584 179120 248000))
;;; Generated autoloads from xpm.el

(autoload 'xpm-grok "xpm" "\
Analyze buffer and prepare internal data structures.
When called as a command, display in the echo area a
summary of image dimensions, cpp and palette.
Set buffer-local variable `xpm--gg' and return its value.
Normally, preparation includes making certain parts of the
buffer intangible.  Optional arg SIMPLE non-nil inhibits that.

\(fn &optional SIMPLE)" t nil)

(autoload 'xpm-generate-buffer "xpm" "\
Return a new buffer in XPM image format.
In this buffer, undo is disabled (see `buffer-enable-undo').

NAME is the buffer and XPM name.  For best interoperation
with other programs, NAME should be a valid C identifier.
WIDTH, HEIGHT and CPP are integers that specify the image
width, height and characters/pixel, respectively.

PALETTE is an alist ((PX . COLOR) ...), where PX is either
a character or string of length CPP, and COLOR is a string.
If COLOR includes a space, it is included directly,
otherwise it is automatically prefixed with \"c \".

For example, to produce palette fragment:

 \"X  c blue\",
 \"Y  s border c green\",

you can specify PALETTE as:

 ((?X . \"blue\")
  (?Y . \"s border c green\"))

This example presumes CPP is 1.

\(fn NAME WIDTH HEIGHT CPP PALETTE)" nil nil)

;;;***

;;;### (autoloads nil "xpm-m2z" "xpm-m2z.el" (22732 17584 187120
;;;;;;  192000))
;;; Generated autoloads from xpm-m2z.el

(autoload 'xpm-m2z-ellipse "xpm-m2z" "\
Return an ellipse with center (CX,CY) and radii RX and RY.
Both CX and CY must be non-integer, preferably
precisely half-way between integers, e.g., 13/2 => 6.5.
The ellipse is represented as a list of unique XPM coords,
with the \"span\", i.e., (- HI LO -1), of the extreme X and Y
components equal to twice the rounded (to integer) value of
RX and RY, respectively.  For example:

 (xpm-m2z-ellipse 1.5 3.5 5.8 4.2)
 => list of length 20

    min  max  span
 X   -3    6    10
 Y    0    7     8

The span is always an even number.  As a special case, if the
absolute value of RX or RY is less than 1, the value is nil.

\(fn CX CY RX RY)" nil nil)

(autoload 'xpm-m2z-circle "xpm-m2z" "\
Like `xpm-m2z-ellipse' with a shared radius RADIUS.

\(fn CX CY RADIUS)" nil nil)

;;;***

;;;### (autoloads nil nil ("xpm-pkg.el") (22732 17584 191120 164000))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; End:
;;; xpm-autoloads.el ends here
