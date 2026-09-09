#!/usr/bin/env bash
# 通用 Debian 12/13 重装 · 个人单文件版 · GPL-3.0
# Network compatibility patch: effective IPv4/IPv6 probing + family-aware downloads
# 上游：https://github.com/bin456789/reinstall
# 固定版本：5db051675101f31bbe2fb3e093432fa4d1af8dcc
# 用法：bash reinstall.sh [--check | --extract-only | 安装选项]
# 默认 SSH 35965；准备后不自动重启。安装会清空系统盘。
set -Eeuo pipefail
umask 077
for cmd in bash mktemp mkdir cat base64 sha256sum; do
    command -v "$cmd" >/dev/null 2>&1 || { printf '缺少命令：%s\n' "$cmd" >&2; exit 1; }
done
if [[ ${1:-} == --extract-only && $# != 1 ]]; then
    printf '%s\n' '--extract-only 不接受其他参数' >&2
    exit 1
fi
FLEET_UNPACK=$(mktemp -d ./fleet-reinstall.XXXXXXXX)
printf '运行目录：%s/%s\n' "$PWD" "${FLEET_UNPACK#./}"
mkdir -p "$FLEET_UNPACK/lib" "$FLEET_UNPACK/payload" "$FLEET_UNPACK/vendor"

# LICENSE
cat >"$FLEET_UNPACK/LICENSE" <<'FILE_c693279643b8cd5d'
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.

  When we speak of free software, we are referring to freedom, not
price.  Our General Public Licenses are designed to make sure that you
have the freedom to distribute copies of free software (and charge for
them if you wish), that you receive source code or can get it if you
want it, that you can change the software or use pieces of it in new
free programs, and that you know you can do these things.

  To protect your rights, we need to prevent others from denying you
these rights or asking you to surrender the rights.  Therefore, you have
certain responsibilities if you distribute copies of the software, or if
you modify it: responsibilities to respect the freedom of others.

  For example, if you distribute copies of such a program, whether
gratis or for a fee, you must pass on to the recipients the same
freedoms that you received.  You must make sure that they, too, receive
or can get the source code.  And you must show them these terms so they
know their rights.

  Developers that use the GNU GPL protect your rights with two steps:
(1) assert copyright on the software, and (2) offer you this License
giving you legal permission to copy, distribute and/or modify it.

  For the developers' and authors' protection, the GPL clearly explains
that there is no warranty for this free software.  For both users' and
authors' sake, the GPL requires that modified versions be marked as
changed, so that their problems will not be attributed erroneously to
authors of previous versions.

  Some devices are designed to deny users access to install or run
modified versions of the software inside them, although the manufacturer
can do so.  This is fundamentally incompatible with the aim of
protecting users' freedom to change the software.  The systematic
pattern of such abuse occurs in the area of products for individuals to
use, which is precisely where it is most unacceptable.  Therefore, we
have designed this version of the GPL to prohibit the practice for those
products.  If such problems arise substantially in other domains, we
stand ready to extend this provision to those domains in future versions
of the GPL, as needed to protect the freedom of users.

  Finally, every program is threatened constantly by software patents.
States should not allow patents to restrict development and use of
software on general-purpose computers, but in those that do, we wish to
avoid the special danger that patents applied to a free program could
make it effectively proprietary.  To prevent this, the GPL assures that
patents cannot be used to render the program non-free.

  The precise terms and conditions for copying, distribution and
modification follow.

                       TERMS AND CONDITIONS

  0. Definitions.

  "This License" refers to version 3 of the GNU General Public License.

  "Copyright" also means copyright-like laws that apply to other kinds of
works, such as semiconductor masks.

  "The Program" refers to any copyrightable work licensed under this
License.  Each licensee is addressed as "you".  "Licensees" and
"recipients" may be individuals or organizations.

  To "modify" a work means to copy from or adapt all or part of the work
in a fashion requiring copyright permission, other than the making of an
exact copy.  The resulting work is called a "modified version" of the
earlier work or a work "based on" the earlier work.

  A "covered work" means either the unmodified Program or a work based
on the Program.

  To "propagate" a work means to do anything with it that, without
permission, would make you directly or secondarily liable for
infringement under applicable copyright law, except executing it on a
computer or modifying a private copy.  Propagation includes copying,
distribution (with or without modification), making available to the
public, and in some countries other activities as well.

  To "convey" a work means any kind of propagation that enables other
parties to make or receive copies.  Mere interaction with a user through
a computer network, with no transfer of a copy, is not conveying.

  An interactive user interface displays "Appropriate Legal Notices"
to the extent that it includes a convenient and prominently visible
feature that (1) displays an appropriate copyright notice, and (2)
tells the user that there is no warranty for the work (except to the
extent that warranties are provided), that licensees may convey the
work under this License, and how to view a copy of this License.  If
the interface presents a list of user commands or options, such as a
menu, a prominent item in the list meets this criterion.

  1. Source Code.

  The "source code" for a work means the preferred form of the work
for making modifications to it.  "Object code" means any non-source
form of a work.

  A "Standard Interface" means an interface that either is an official
standard defined by a recognized standards body, or, in the case of
interfaces specified for a particular programming language, one that
is widely used among developers working in that language.

  The "System Libraries" of an executable work include anything, other
than the work as a whole, that (a) is included in the normal form of
packaging a Major Component, but which is not part of that Major
Component, and (b) serves only to enable use of the work with that
Major Component, or to implement a Standard Interface for which an
implementation is available to the public in source code form.  A
"Major Component", in this context, means a major essential component
(kernel, window system, and so on) of the specific operating system
(if any) on which the executable work runs, or a compiler used to
produce the work, or an object code interpreter used to run it.

  The "Corresponding Source" for a work in object code form means all
the source code needed to generate, install, and (for an executable
work) run the object code and to modify the work, including scripts to
control those activities.  However, it does not include the work's
System Libraries, or general-purpose tools or generally available free
programs which are used unmodified in performing those activities but
which are not part of the work.  For example, Corresponding Source
includes interface definition files associated with source files for
the work, and the source code for shared libraries and dynamically
linked subprograms that the work is specifically designed to require,
such as by intimate data communication or control flow between those
subprograms and other parts of the work.

  The Corresponding Source need not include anything that users
can regenerate automatically from other parts of the Corresponding
Source.

  The Corresponding Source for a work in source code form is that
same work.

  2. Basic Permissions.

  All rights granted under this License are granted for the term of
copyright on the Program, and are irrevocable provided the stated
conditions are met.  This License explicitly affirms your unlimited
permission to run the unmodified Program.  The output from running a
covered work is covered by this License only if the output, given its
content, constitutes a covered work.  This License acknowledges your
rights of fair use or other equivalent, as provided by copyright law.

  You may make, run and propagate covered works that you do not
convey, without conditions so long as your license otherwise remains
in force.  You may convey covered works to others for the sole purpose
of having them make modifications exclusively for you, or provide you
with facilities for running those works, provided that you comply with
the terms of this License in conveying all material for which you do
not control copyright.  Those thus making or running the covered works
for you must do so exclusively on your behalf, under your direction
and control, on terms that prohibit them from making any copies of
your copyrighted material outside their relationship with you.

  Conveying under any other circumstances is permitted solely under
the conditions stated below.  Sublicensing is not allowed; section 10
makes it unnecessary.

  3. Protecting Users' Legal Rights From Anti-Circumvention Law.

  No covered work shall be deemed part of an effective technological
measure under any applicable law fulfilling obligations under article
11 of the WIPO copyright treaty adopted on 20 December 1996, or
similar laws prohibiting or restricting circumvention of such
measures.

  When you convey a covered work, you waive any legal power to forbid
circumvention of technological measures to the extent such circumvention
is effected by exercising rights under this License with respect to
the covered work, and you disclaim any intention to limit operation or
modification of the work as a means of enforcing, against the work's
users, your or third parties' legal rights to forbid circumvention of
technological measures.

  4. Conveying Verbatim Copies.

  You may convey verbatim copies of the Program's source code as you
receive it, in any medium, provided that you conspicuously and
appropriately publish on each copy an appropriate copyright notice;
keep intact all notices stating that this License and any
non-permissive terms added in accord with section 7 apply to the code;
keep intact all notices of the absence of any warranty; and give all
recipients a copy of this License along with the Program.

  You may charge any price or no price for each copy that you convey,
and you may offer support or warranty protection for a fee.

  5. Conveying Modified Source Versions.

  You may convey a work based on the Program, or the modifications to
produce it from the Program, in the form of source code under the
terms of section 4, provided that you also meet all of these conditions:

    a) The work must carry prominent notices stating that you modified
    it, and giving a relevant date.

    b) The work must carry prominent notices stating that it is
    released under this License and any conditions added under section
    7.  This requirement modifies the requirement in section 4 to
    "keep intact all notices".

    c) You must license the entire work, as a whole, under this
    License to anyone who comes into possession of a copy.  This
    License will therefore apply, along with any applicable section 7
    additional terms, to the whole of the work, and all its parts,
    regardless of how they are packaged.  This License gives no
    permission to license the work in any other way, but it does not
    invalidate such permission if you have separately received it.

    d) If the work has interactive user interfaces, each must display
    Appropriate Legal Notices; however, if the Program has interactive
    interfaces that do not display Appropriate Legal Notices, your
    work need not make them do so.

  A compilation of a covered work with other separate and independent
works, which are not by their nature extensions of the covered work,
and which are not combined with it such as to form a larger program,
in or on a volume of a storage or distribution medium, is called an
"aggregate" if the compilation and its resulting copyright are not
used to limit the access or legal rights of the compilation's users
beyond what the individual works permit.  Inclusion of a covered work
in an aggregate does not cause this License to apply to the other
parts of the aggregate.

  6. Conveying Non-Source Forms.

  You may convey a covered work in object code form under the terms
of sections 4 and 5, provided that you also convey the
machine-readable Corresponding Source under the terms of this License,
in one of these ways:

    a) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by the
    Corresponding Source fixed on a durable physical medium
    customarily used for software interchange.

    b) Convey the object code in, or embodied in, a physical product
    (including a physical distribution medium), accompanied by a
    written offer, valid for at least three years and valid for as
    long as you offer spare parts or customer support for that product
    model, to give anyone who possesses the object code either (1) a
    copy of the Corresponding Source for all the software in the
    product that is covered by this License, on a durable physical
    medium customarily used for software interchange, for a price no
    more than your reasonable cost of physically performing this
    conveying of source, or (2) access to copy the
    Corresponding Source from a network server at no charge.

    c) Convey individual copies of the object code with a copy of the
    written offer to provide the Corresponding Source.  This
    alternative is allowed only occasionally and noncommercially, and
    only if you received the object code with such an offer, in accord
    with subsection 6b.

    d) Convey the object code by offering access from a designated
    place (gratis or for a charge), and offer equivalent access to the
    Corresponding Source in the same way through the same place at no
    further charge.  You need not require recipients to copy the
    Corresponding Source along with the object code.  If the place to
    copy the object code is a network server, the Corresponding Source
    may be on a different server (operated by you or a third party)
    that supports equivalent copying facilities, provided you maintain
    clear directions next to the object code saying where to find the
    Corresponding Source.  Regardless of what server hosts the
    Corresponding Source, you remain obligated to ensure that it is
    available for as long as needed to satisfy these requirements.

    e) Convey the object code using peer-to-peer transmission, provided
    you inform other peers where the object code and Corresponding
    Source of the work are being offered to the general public at no
    charge under subsection 6d.

  A separable portion of the object code, whose source code is excluded
from the Corresponding Source as a System Library, need not be
included in conveying the object code work.

  A "User Product" is either (1) a "consumer product", which means any
tangible personal property which is normally used for personal, family,
or household purposes, or (2) anything designed or sold for incorporation
into a dwelling.  In determining whether a product is a consumer product,
doubtful cases shall be resolved in favor of coverage.  For a particular
product received by a particular user, "normally used" refers to a
typical or common use of that class of product, regardless of the status
of the particular user or of the way in which the particular user
actually uses, or expects or is expected to use, the product.  A product
is a consumer product regardless of whether the product has substantial
commercial, industrial or non-consumer uses, unless such uses represent
the only significant mode of use of the product.

  "Installation Information" for a User Product means any methods,
procedures, authorization keys, or other information required to install
and execute modified versions of a covered work in that User Product from
a modified version of its Corresponding Source.  The information must
suffice to ensure that the continued functioning of the modified object
code is in no case prevented or interfered with solely because
modification has been made.

  If you convey an object code work under this section in, or with, or
specifically for use in, a User Product, and the conveying occurs as
part of a transaction in which the right of possession and use of the
User Product is transferred to the recipient in perpetuity or for a
fixed term (regardless of how the transaction is characterized), the
Corresponding Source conveyed under this section must be accompanied
by the Installation Information.  But this requirement does not apply
if neither you nor any third party retains the ability to install
modified object code on the User Product (for example, the work has
been installed in ROM).

  The requirement to provide Installation Information does not include a
requirement to continue to provide support service, warranty, or updates
for a work that has been modified or installed by the recipient, or for
the User Product in which it has been modified or installed.  Access to a
network may be denied when the modification itself materially and
adversely affects the operation of the network or violates the rules and
protocols for communication across the network.

  Corresponding Source conveyed, and Installation Information provided,
in accord with this section must be in a format that is publicly
documented (and with an implementation available to the public in
source code form), and must require no special password or key for
unpacking, reading or copying.

  7. Additional Terms.

  "Additional permissions" are terms that supplement the terms of this
License by making exceptions from one or more of its conditions.
Additional permissions that are applicable to the entire Program shall
be treated as though they were included in this License, to the extent
that they are valid under applicable law.  If additional permissions
apply only to part of the Program, that part may be used separately
under those permissions, but the entire Program remains governed by
this License without regard to the additional permissions.

  When you convey a copy of a covered work, you may at your option
remove any additional permissions from that copy, or from any part of
it.  (Additional permissions may be written to require their own
removal in certain cases when you modify the work.)  You may place
additional permissions on material, added by you to a covered work,
for which you have or can give appropriate copyright permission.

  Notwithstanding any other provision of this License, for material you
add to a covered work, you may (if authorized by the copyright holders of
that material) supplement the terms of this License with terms:

    a) Disclaiming warranty or limiting liability differently from the
    terms of sections 15 and 16 of this License; or

    b) Requiring preservation of specified reasonable legal notices or
    author attributions in that material or in the Appropriate Legal
    Notices displayed by works containing it; or

    c) Prohibiting misrepresentation of the origin of that material, or
    requiring that modified versions of such material be marked in
    reasonable ways as different from the original version; or

    d) Limiting the use for publicity purposes of names of licensors or
    authors of the material; or

    e) Declining to grant rights under trademark law for use of some
    trade names, trademarks, or service marks; or

    f) Requiring indemnification of licensors and authors of that
    material by anyone who conveys the material (or modified versions of
    it) with contractual assumptions of liability to the recipient, for
    any liability that these contractual assumptions directly impose on
    those licensors and authors.

  All other non-permissive additional terms are considered "further
restrictions" within the meaning of section 10.  If the Program as you
received it, or any part of it, contains a notice stating that it is
governed by this License along with a term that is a further
restriction, you may remove that term.  If a license document contains
a further restriction but permits relicensing or conveying under this
License, you may add to a covered work material governed by the terms
of that license document, provided that the further restriction does
not survive such relicensing or conveying.

  If you add terms to a covered work in accord with this section, you
must place, in the relevant source files, a statement of the
additional terms that apply to those files, or a notice indicating
where to find the applicable terms.

  Additional terms, permissive or non-permissive, may be stated in the
form of a separately written license, or stated as exceptions;
the above requirements apply either way.

  8. Termination.

  You may not propagate or modify a covered work except as expressly
provided under this License.  Any attempt otherwise to propagate or
modify it is void, and will automatically terminate your rights under
this License (including any patent licenses granted under the third
paragraph of section 11).

  However, if you cease all violation of this License, then your
license from a particular copyright holder is reinstated (a)
provisionally, unless and until the copyright holder explicitly and
finally terminates your license, and (b) permanently, if the copyright
holder fails to notify you of the violation by some reasonable means
prior to 60 days after the cessation.

  Moreover, your license from a particular copyright holder is
reinstated permanently if the copyright holder notifies you of the
violation by some reasonable means, this is the first time you have
received notice of violation of this License (for any work) from that
copyright holder, and you cure the violation prior to 30 days after
your receipt of the notice.

  Termination of your rights under this section does not terminate the
licenses of parties who have received copies or rights from you under
this License.  If your rights have been terminated and not permanently
reinstated, you do not qualify to receive new licenses for the same
material under section 10.

  9. Acceptance Not Required for Having Copies.

  You are not required to accept this License in order to receive or
run a copy of the Program.  Ancillary propagation of a covered work
occurring solely as a consequence of using peer-to-peer transmission
to receive a copy likewise does not require acceptance.  However,
nothing other than this License grants you permission to propagate or
modify any covered work.  These actions infringe copyright if you do
not accept this License.  Therefore, by modifying or propagating a
covered work, you indicate your acceptance of this License to do so.

  10. Automatic Licensing of Downstream Recipients.

  Each time you convey a covered work, the recipient automatically
receives a license from the original licensors, to run, modify and
propagate that work, subject to this License.  You are not responsible
for enforcing compliance by third parties with this License.

  An "entity transaction" is a transaction transferring control of an
organization, or substantially all assets of one, or subdividing an
organization, or merging organizations.  If propagation of a covered
work results from an entity transaction, each party to that
transaction who receives a copy of the work also receives whatever
licenses to the work the party's predecessor in interest had or could
give under the previous paragraph, plus a right to possession of the
Corresponding Source of the work from the predecessor in interest, if
the predecessor has it or can get it with reasonable efforts.

  You may not impose any further restrictions on the exercise of the
rights granted or affirmed under this License.  For example, you may
not impose a license fee, royalty, or other charge for exercise of
rights granted under this License, and you may not initiate litigation
(including a cross-claim or counterclaim in a lawsuit) alleging that
any patent claim is infringed by making, using, selling, offering for
sale, or importing the Program or any portion of it.

  11. Patents.

  A "contributor" is a copyright holder who authorizes use under this
License of the Program or a work on which the Program is based.  The
work thus licensed is called the contributor's "contributor version".

  A contributor's "essential patent claims" are all patent claims
owned or controlled by the contributor, whether already acquired or
hereafter acquired, that would be infringed by some manner, permitted
by this License, of making, using, or selling its contributor version,
but do not include claims that would be infringed only as a
consequence of further modification of the contributor version.  For
purposes of this definition, "control" includes the right to grant
patent sublicenses in a manner consistent with the requirements of
this License.

  Each contributor grants you a non-exclusive, worldwide, royalty-free
patent license under the contributor's essential patent claims, to
make, use, sell, offer for sale, import and otherwise run, modify and
propagate the contents of its contributor version.

  In the following three paragraphs, a "patent license" is any express
agreement or commitment, however denominated, not to enforce a patent
(such as an express permission to practice a patent or covenant not to
sue for patent infringement).  To "grant" such a patent license to a
party means to make such an agreement or commitment not to enforce a
patent against the party.

  If you convey a covered work, knowingly relying on a patent license,
and the Corresponding Source of the work is not available for anyone
to copy, free of charge and under the terms of this License, through a
publicly available network server or other readily accessible means,
then you must either (1) cause the Corresponding Source to be so
available, or (2) arrange to deprive yourself of the benefit of the
patent license for this particular work, or (3) arrange, in a manner
consistent with the requirements of this License, to extend the patent
license to downstream recipients.  "Knowingly relying" means you have
actual knowledge that, but for the patent license, your conveying the
covered work in a country, or your recipient's use of the covered work
in a country, would infringe one or more identifiable patents in that
country that you have reason to believe are valid.

  If, pursuant to or in connection with a single transaction or
arrangement, you convey, or propagate by procuring conveyance of, a
covered work, and grant a patent license to some of the parties
receiving the covered work authorizing them to use, propagate, modify
or convey a specific copy of the covered work, then the patent license
you grant is automatically extended to all recipients of the covered
work and works based on it.

  A patent license is "discriminatory" if it does not include within
the scope of its coverage, prohibits the exercise of, or is
conditioned on the non-exercise of one or more of the rights that are
specifically granted under this License.  You may not convey a covered
work if you are a party to an arrangement with a third party that is
in the business of distributing software, under which you make payment
to the third party based on the extent of your activity of conveying
the work, and under which the third party grants, to any of the
parties who would receive the covered work from you, a discriminatory
patent license (a) in connection with copies of the covered work
conveyed by you (or copies made from those copies), or (b) primarily
for and in connection with specific products or compilations that
contain the covered work, unless you entered into that arrangement,
or that patent license was granted, prior to 28 March 2007.

  Nothing in this License shall be construed as excluding or limiting
any implied license or other defenses to infringement that may
otherwise be available to you under applicable patent law.

  12. No Surrender of Others' Freedom.

  If conditions are imposed on you (whether by court order, agreement or
otherwise) that contradict the conditions of this License, they do not
excuse you from the conditions of this License.  If you cannot convey a
covered work so as to satisfy simultaneously your obligations under this
License and any other pertinent obligations, then as a consequence you may
not convey it at all.  For example, if you agree to terms that obligate you
to collect a royalty for further conveying from those to whom you convey
the Program, the only way you could satisfy both those terms and this
License would be to refrain entirely from conveying the Program.

  13. Use with the GNU Affero General Public License.

  Notwithstanding any other provision of this License, you have
permission to link or combine any covered work with a work licensed
under version 3 of the GNU Affero General Public License into a single
combined work, and to convey the resulting work.  The terms of this
License will continue to apply to the part which is the covered work,
but the special requirements of the GNU Affero General Public License,
section 13, concerning interaction through a network will apply to the
combination as such.

  14. Revised Versions of this License.

  The Free Software Foundation may publish revised and/or new versions of
the GNU General Public License from time to time.  Such new versions will
be similar in spirit to the present version, but may differ in detail to
address new problems or concerns.

  Each version is given a distinguishing version number.  If the
Program specifies that a certain numbered version of the GNU General
Public License "or any later version" applies to it, you have the
option of following the terms and conditions either of that numbered
version or of any later version published by the Free Software
Foundation.  If the Program does not specify a version number of the
GNU General Public License, you may choose any version ever published
by the Free Software Foundation.

  If the Program specifies that a proxy can decide which future
versions of the GNU General Public License can be used, that proxy's
public statement of acceptance of a version permanently authorizes you
to choose that version for the Program.

  Later license versions may give you additional or different
permissions.  However, no additional obligations are imposed on any
author or copyright holder as a result of your choosing to follow a
later version.

  15. Disclaimer of Warranty.

  THERE IS NO WARRANTY FOR THE PROGRAM, TO THE EXTENT PERMITTED BY
APPLICABLE LAW.  EXCEPT WHEN OTHERWISE STATED IN WRITING THE COPYRIGHT
HOLDERS AND/OR OTHER PARTIES PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY
OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE.  THE ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE PROGRAM
IS WITH YOU.  SHOULD THE PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF
ALL NECESSARY SERVICING, REPAIR OR CORRECTION.

  16. Limitation of Liability.

  IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MODIFIES AND/OR CONVEYS
THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES, INCLUDING ANY
GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE
USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED TO LOSS OF
DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD
PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER PROGRAMS),
EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.

  17. Interpretation of Sections 15 and 16.

  If the disclaimer of warranty and limitation of liability provided
above cannot be given local legal effect according to their terms,
reviewing courts shall apply local law that most closely approximates
an absolute waiver of all civil liability in connection with the
Program, unless a warranty or assumption of liability accompanies a
copy of the Program in return for a fee.

                     END OF TERMS AND CONDITIONS

            How to Apply These Terms to Your New Programs

  If you develop a new program, and you want it to be of the greatest
possible use to the public, the best way to achieve this is to make it
free software which everyone can redistribute and change under these terms.

  To do so, attach the following notices to the program.  It is safest
to attach them to the start of each source file to most effectively
state the exclusion of warranty; and each file should have at least
the "copyright" line and a pointer to where the full notice is found.

    <one line to give the program's name and a brief idea of what it does.>
    Copyright (C) <year>  <name of author>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.

Also add information on how to contact you by electronic and paper mail.

  If the program does terminal interaction, make it output a short
notice like this when it starts in an interactive mode:

    <program>  Copyright (C) <year>  <name of author>
    This program comes with ABSOLUTELY NO WARRANTY; for details type `show w'.
    This is free software, and you are welcome to redistribute it
    under certain conditions; type `show c' for details.

The hypothetical commands `show w' and `show c' should show the appropriate
parts of the General Public License.  Of course, your program's commands
might be different; for a GUI interface, you would use an "about box".

  You should also get your employer (if you work as a programmer) or school,
if any, to sign a "copyright disclaimer" for the program, if necessary.
For more information on this, and how to apply and follow the GNU GPL, see
<https://www.gnu.org/licenses/>.

  The GNU General Public License does not permit incorporating your program
into proprietary programs.  If your program is a subroutine library, you
may consider it more useful to permit linking proprietary applications with
the library.  If this is what you want to do, use the GNU Lesser General
Public License instead of this License.  But first, please read
<https://www.gnu.org/licenses/why-not-lgpl.html>.
FILE_c693279643b8cd5d

# lib/adapter.sh
cat >"$FLEET_UNPACK/lib/adapter.sh" <<'FILE_ffad207ed6b53f98'
#!/usr/bin/env bash
# Loaded only by the pinned vendor engine. Definitions do not mutate the host.
fleet_local_fetch() {
    # 125 means "not a bundled source request": let upstream curl handle it.
    local url='' output='' remote=no arg rel
    while (($#)); do
        arg=$1; shift
        case "$arg" in
            -o|--output|-Lo|-Lfo|-fsSLo) (($#)) || return 125; output=$1; shift ;;
            -O|-LO|-OL|--remote-name) remote=yes ;;
            -L|-f|-s|-S|-fsSL|-sSL) ;;
            https://raw.githubusercontent.com/bin456789/reinstall/5db051675101f31bbe2fb3e093432fa4d1af8dcc/*) url=$arg ;;
            *) return 125 ;;
        esac
    done
    [[ -n $url && -n ${FLEET_BUNDLE:-} ]] || return 125
    rel=${url#https://raw.githubusercontent.com/bin456789/reinstall/5db051675101f31bbe2fb3e093432fa4d1af8dcc/}
    [[ $rel != */* && -f $FLEET_BUNDLE/vendor/$rel ]] || return 125
    if [[ $remote == yes ]]; then output=$rel; fi
    if [[ -n $output ]]; then
        command cp -- "$FLEET_BUNDLE/vendor/$rel" "$output"
    else
        command cat -- "$FLEET_BUNDLE/vendor/$rel"
    fi
}
fleet_load_inputs() {
    [[ -n ${FLEET_STAGE:-} && -d $FLEET_STAGE ]] || error_and_exit 'Run the fleet frontend, not vendor/reinstall.sh directly.'
    if [[ -f $FLEET_STAGE/password ]]; then password=$(cat "$FLEET_STAGE/password"); fi
    xda=${FLEET_DISK##*/}
}
fleet_customize_initrd() {
    local dest=$1
    [[ $nextos_distro == debian ]] || error_and_exit 'Fleet payload supports Debian Installer only.'
    command cp "$FLEET_BUNDLE/vendor/debian.cfg" "$dest/preseed.cfg"
    command cp "$FLEET_BUNDLE/payload/installer-swap.sh" "$dest/fleet-installer-swap.sh"
    command cp "$FLEET_BUNDLE/payload/late.sh" "$dest/fleet-late.sh"
    mkdir -p "$dest/fleet-payload"
    command cp "$FLEET_BUNDLE/payload/firstboot.sh" "$FLEET_BUNDLE/payload/assets.tsv" \
        "$FLEET_BUNDLE/payload/fleet-firstboot.service" "$FLEET_BUNDLE/payload/fleet-firstboot.timer" "$dest/fleet-payload/"
    command cp "$FLEET_STAGE/config.sh" "$dest/fleet-payload/config.sh"
    if [[ -s $FLEET_STAGE/keys ]]; then
        command cp "$FLEET_STAGE/keys" "$dest/fleet-payload/ssh_keys"
    fi
    command cp "$FLEET_STAGE/dns.conf" "$dest/fleet-dns.conf"
    local ca_file
    ca_file=''
    for candidate in /etc/ssl/certs/ca-certificates.crt /etc/pki/tls/certs/ca-bundle.crt; do
        if [[ -s $candidate ]]; then ca_file=$candidate; break; fi
    done
    [[ -n $ca_file ]] || error_and_exit 'No host CA bundle available for installer HTTPS validation.'
    command cp "$ca_file" "$dest/fleet-ca.crt"
    # Runs after upstream netcfg recovery but before trans.sh snapshots the network.
    cat >>"$dest/initrd-network.sh" <<'EOF'

# Fleet: explicit/host upstream DNS, filtered before reboot. No hard-coded public DNS64.
if [ -s /fleet-dns.conf ]; then
    cat /fleet-dns.conf >/etc/resolv.conf
fi
EOF
    # Fail network stage before partman if the actual Debian repository cannot be read.
    cat >>"$dest/var/lib/dpkg/info/netcfg.postinst" <<'EOF'

fleet_suite=trixie
grep -q '^DEBIAN_VER=12$' /fleet-payload/config.sh && fleet_suite=bookworm
wget --ca-certificate=/fleet-ca.crt -T 30 -t 3 -O /tmp/fleet-InRelease "https://deb.debian.org/debian/dists/$fleet_suite/InRelease" || exit 1
[ -s /tmp/fleet-InRelease ] || exit 1
rm -f /tmp/fleet-InRelease
EOF
    chmod 700 "$dest/fleet-late.sh" "$dest/fleet-installer-swap.sh"
}
FILE_ffad207ed6b53f98

# lib/common.sh
cat >"$FLEET_UNPACK/lib/common.sh" <<'FILE_cfcb1fb44601d83d'
#!/usr/bin/env bash
die() { printf '错误：%s\n' "$*" >&2; exit 1; }
need_value() { [[ $# -ge 2 && -n $2 && $2 != --* ]] || die "$1 缺少参数"; }
valid_user() { [[ $1 =~ ^[a-z_][a-z0-9_-]{0,30}$ ]]; }
valid_port() { [[ $1 =~ ^[0-9]{1,5}$ ]] && ((10#$1 >= 1 && 10#$1 <= 65535)); }
valid_dns() {
    local ip=${1,,} item count=0
    local -a parts
    if [[ $ip == *:* ]]; then
        [[ $ip =~ ^[0-9a-f:]+$ && $ip != *:::* ]] || return 1
        case "$ip" in fe[89ab][0-9a-f]:*|ff*) return 1 ;; esac
        [[ ! $ip =~ ^[0:]+$ && ! $ip =~ ^(0*:)*0*1$ ]] || return 1
        if [[ $ip == *::* ]]; then
            [[ ${ip#*::} != *::* ]] || return 1
        else
            [[ $ip != :* && $ip != *: ]] || return 1
        fi
        [[ $ip != :* || $ip == ::* ]] || return 1
        [[ $ip != *: || $ip == *:: ]] || return 1
        IFS=: read -r -a parts <<<"$ip"
        for item in "${parts[@]}"; do
            [[ -n $item ]] || continue
            [[ $item =~ ^[0-9a-f]{1,4}$ ]] || return 1
            count=$((count + 1))
        done
        if [[ $ip == *::* ]]; then ((count < 8)); else ((count == 8)); fi
    else
        [[ $ip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] || return 1
        case "$ip" in 127.*|0.*) return 1 ;; esac
        IFS=. read -r -a parts <<<"$ip"
        for item in "${parts[@]}"; do
            [[ ${#item} -le 3 ]] && ((10#$item <= 255)) || return 1
        done
        ((10#${parts[0]} < 224))
    fi
}
download() {
    local url=$1 dst=$2
    local -a family_args=()
    case ${NETWORK_TYPE:-unknown} in
        ipv4-only) family_args=(-4) ;;
        ipv6-only) family_args=(-6) ;;
    esac
    curl "${family_args[@]}" --fail --show-error --silent --location --proto '=https' --proto-redir '=https' \
        --connect-timeout 15 --max-time 600 --retry 3 --retry-delay 3 \
        --output "$dst.part" "$url"
    [[ -s $dst.part ]] || die "download result is empty: $url"
    mv -- "$dst.part" "$dst"
}

# Probe the protocol family against the actual Debian repository needed by the
# reinstall. A default route alone is NOT proof of Internet reachability.
probe_effective_network() {
    local url=$1
    local v4=no v6=no

    if [[ -n $(ip -4 route show default) ]] &&
       command curl -4 --fail --silent --show-error --location \
           --connect-timeout 6 --max-time 15 --retry 1 \
           --output /dev/null "$url"; then
        v4=yes
    fi

    if [[ -n $(ip -6 route show default) ]] &&
       command curl -6 --fail --silent --show-error --location \
           --connect-timeout 6 --max-time 15 --retry 1 \
           --output /dev/null "$url"; then
        v6=yes
    fi

    IPV4_INTERNET=$v4
    IPV6_INTERNET=$v6
    case "$v4:$v6" in
        yes:yes) NETWORK_TYPE=dual-stack ;;
        yes:no)  NETWORK_TYPE=ipv4-only ;;
        no:yes)  NETWORK_TYPE=ipv6-only ;;
        no:no)   die "IPv4 and IPv6 both failed to reach Debian repository: $url" ;;
    esac

    export NETWORK_TYPE IPV4_INTERNET IPV6_INTERNET
    printf 'Internet probe: IPv4=%s | IPv6=%s | effective network=%s\n' \
        "$IPV4_INTERNET" "$IPV6_INTERNET" "$NETWORK_TYPE"
}

validate_keys() {
    local src=$1 line count=0
    while IFS= read -r line || [[ -n $line ]]; do
        [[ -n $line && $line != '#'* ]] || continue
        # Options before key type are intentionally rejected: never silently strip restrictions.
        [[ $line =~ ^(ssh-ed25519|ssh-rsa|ecdsa-sha2-nistp(256|384|521))[[:space:]] ]] || die '公钥格式不支持；请使用无前置选项的完整公钥'
        printf '%s\n' "$line" >"$STAGE/key-check"
        ssh-keygen -lf "$STAGE/key-check" >/dev/null || die '公钥内容校验失败'
        count=$((count + 1))
    done <"$src"
    ((count > 0)) || die '没有有效公钥'
}
inspect_host() {
    [[ $(uname -s) == Linux ]] || die '请在 Linux 服务器中运行'
    ARCH=$(uname -m)
    [[ $ARCH == x86_64 || $ARCH == aarch64 ]] || die "暂不支持架构：$ARCH"
    for cmd in ip lsblk findmnt awk sort readlink; do
        command -v "$cmd" >/dev/null || die "缺少只读检测工具：$cmd"
    done
    if command -v systemd-detect-virt >/dev/null && systemd-detect-virt --container --quiet; then
        die '不支持容器内重装'
    fi
    local root_source root_fs candidates routes4 routes6
    root_fs=$(findmnt -n -o FSTYPE /)
    case "$root_fs" in overlay|tmpfs|rootfs) die '不能在安装器、容器或 Live 系统里准备重装' ;; esac
    root_source=$(findmnt -n -o SOURCE /)
    root_source=${root_source%%\[*}
    if lsblk -srn -o TYPE "$root_source" | grep -Eq '^(crypt|raid[0-9]+|md)$'; then
        die '本版不自动处理加密根分区或软件 RAID'
    fi
    candidates=$(lsblk -srnp -o NAME,TYPE "$root_source" | awk '$2=="disk" {print $1}' | sort -u)
    [[ -n $candidates && $candidates != *$'\n'* ]] || die '根系统跨多个磁盘或无法识别；本版拒绝自动选择'
    DETECTED_DISK=$(readlink -f -- "$candidates")
    [[ -b $DETECTED_DISK ]] || die '目标不是块设备'
    if [[ -n $DISK ]]; then
        [[ $(readlink -f -- "$DISK") == "$DETECTED_DISK" ]] || die '--disk 与根系统所在磁盘不一致'
    fi
    RAM_MB=$(awk '/^MemTotal:/ {print int($2/1024)}' /proc/meminfo)
    DISK_BYTES=$(lsblk -bdn -o SIZE "$DETECTED_DISK")
    [[ $RAM_MB =~ ^[0-9]+$ && $DISK_BYTES =~ ^[0-9]+$ ]] || die '无法读取内存或磁盘容量'
    ((RAM_MB >= 220)) || die '内存太小；需要至少约 256MB 标称内存'
    ((DISK_BYTES >= 3*1024*1024*1024)) || die '本封装要求系统盘至少 3GiB'
    routes4=$(ip -4 route show default)
    routes6=$(ip -6 route show default)
    local rules
    for family in 4 6; do
        rules=$(ip -"$family" rule show)
        if [[ -n $(awk '$0 !~ /from all lookup (local|main|default)$/ {print}' <<<"$rules") ]]; then
            die '检测到自定义策略路由；本封装需要单独适配后使用'
        fi
    done
    NETWORK_TYPE=unknown
    [[ -z $routes4 ]] || NETWORK_TYPE=ipv4-only
    if [[ -n $routes6 ]]; then
        if [[ -n $routes4 ]]; then NETWORK_TYPE=dual-stack; else NETWORK_TYPE=ipv6-only; fi
    fi
    [[ $NETWORK_TYPE != unknown ]] || die '没有默认路由；请先在原系统恢复网络'
    local routes iface
    for routes in "$routes4" "$routes6"; do
        [[ -n $routes ]] || continue
        [[ $routes != *$'\n'* && $routes != *nexthop* ]] || die '本版暂不接管多默认路由/ECMP 网络'
        iface=$(awk '{for(i=1;i<=NF;i++) if($i=="dev") {print $(i+1); exit}}' <<<"$routes")
        [[ -n $iface && -e /sys/class/net/$iface/device ]] || die '默认出口不是可识别的独立网卡（VLAN/桥接/隧道需要专门适配）'
    done
    printf '架构：%s | 可见内存：%sMiB | 网络：%s（根据路由，未证明出网）\n' "$ARCH" "$RAM_MB" "$NETWORK_TYPE"
    printf '根系统磁盘：%s | 容量：%s bytes\n' "$DETECTED_DISK" "$DISK_BYTES"
    if [[ -d /sys/firmware/efi ]]; then printf '启动方式：UEFI\n'; else printf '启动方式：BIOS\n'; fi
    ip -o link show
    ip -4 addr show scope global
    ip -6 addr show scope global
    printf '%s\n%s\n' "$routes4" "$routes6"
    printf 'DNS：\n'; awk '$1=="nameserver" {print}' /etc/resolv.conf
}
FILE_cfcb1fb44601d83d

# payload/assets.tsv
cat >"$FLEET_UNPACK/payload/assets.tsv" <<'FILE_9724d884ccf5a55d'
realm	amd64	b1cc335547bea8bb2a88178bef12ec7f2363e36200e7ea1d4e1e67627929bf65	https://github.com/zhboner/realm/releases/download/v2.9.6/realm-x86_64-unknown-linux-musl.tar.gz
realm	arm64	f4c0318dd86854da483dcb7645b4f39cae2cc3f91c688fef969d53220b949488	https://github.com/zhboner/realm/releases/download/v2.9.6/realm-aarch64-unknown-linux-musl.tar.gz
sui	amd64	60dbad71f31121ec4705470e4671cb93d30b3bb2e619884816c75388d386eb76	https://github.com/alireza0/s-ui/releases/download/v1.6.0/s-ui-linux-amd64.tar.gz
sui	arm64	7ee27bfcf34e5442958310689831010b1e3e19f1868c6548b1b3d13e3dec130a	https://github.com/alireza0/s-ui/releases/download/v1.6.0/s-ui-linux-arm64.tar.gz
FILE_9724d884ccf5a55d

# payload/firstboot.sh
cat >"$FLEET_UNPACK/payload/firstboot.sh" <<'FILE_8e99cf57ef97fff6'
#!/usr/bin/env bash
# Debian-only, resumable provisioning. IPv6 is disabled only when explicitly requested and IPv4 was verified.
set -Eeuo pipefail
umask 077
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$BASE/config.sh"
STATE=/var/lib/fleet-firstboot
mkdir -p "$STATE"
exec 9>"$STATE/lock"
flock -n 9 || exit 0
export DEBIAN_FRONTEND=noninteractive
failures=0
pending_optional=0
: >"$STATE/last-run.status"

run_step() {
    local name=$1 rc
    shift
    if [[ -f $STATE/$name.done ]]; then
        printf '%s: already complete\n' "$name" >>"$STATE/last-run.status"
        return 0
    fi
    printf '\n[START] %s\n' "$name"
    # Do NOT call the subshell in an if/&& list: that would disable errexit inside functions.
    set +e
    (set -Eeuo pipefail; "$@")
    rc=$?
    set -e
    if ((rc == 0)); then
        : >"$STATE/$name.done"
        printf '%s: OK\n' "$name" >>"$STATE/last-run.status"
    else
        failures=$((failures + 1))
        printf '%s: FAILED (%s); will retry\n' "$name" "$rc" | tee -a "$STATE/last-run.status"
    fi
}
mark_optional_skipped() {
    local name=$1 reason=$2
    pending_optional=1
    printf '%s: SKIPPED (%s); manual retry available\n' "$name" "$reason" | tee -a "$STATE/last-run.status"
}
github_optional_available() {
    # On an IPv6-only host, GitHub Releases may be unavailable even though Debian and
    # raw.githubusercontent.com work. Treat that as a temporary optional dependency,
    # not as a failure of the base system.
    [[ ${NETWORK_TYPE:-unknown} == ipv6-only ]] || return 0
    curl -6 --fail --silent --location --head --proto '=https' --proto-redir '=https' \
        --connect-timeout 8 --max-time 15 https://github.com/ >/dev/null 2>&1
}
apt_install() {
    apt-get -o DPkg::Lock::Timeout=180 -o Acquire::Retries=3 install -y --no-install-recommends "$@"
}
setup_base() {
    apt-get -o Acquire::Retries=3 update
    apt_install ca-certificates curl openssl tar iproute2 systemd-timesyncd
    [[ -f /usr/share/zoneinfo/$TIMEZONE ]]
    ln -sfn "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    printf '%s\n' "$TIMEZONE" >/etc/timezone
    systemctl enable --now systemd-timesyncd
    case "$(systemd-detect-virt || true)" in
        kvm|qemu) apt_install qemu-guest-agent; systemctl enable qemu-guest-agent || true ;;
    esac
}
setup_swap() {
    # Respect any existing permanent swap, including administrator changes on retries.
    if awk '!/^#/ && $3=="swap" {found=1} END {exit !found}' /etc/fstab; then return 0; fi
    local ram available want budget part=/swapfile.fleet-building
    ram=$(awk '/^MemTotal:/ {print int($2/1024)}' /proc/meminfo)
    if ((ram <= 1024)); then want=1024; elif ((ram <= 4096)); then want=2048; else want=4096; fi
    available=$(df -Pm / | awk 'NR==2 {print $4}')
    budget=$((available / 4))
    ((budget >= 128)) || { echo 'Not enough free space for permanent swap' >&2; return 1; }
    ((want <= budget)) || want=$budget
    [[ $(findmnt -n -o FSTYPE /) == ext4 ]] || { echo 'Automatic swapfile requires ext4; configure swap manually' >&2; return 1; }
    if [[ ! -e /swapfile ]]; then
        # Do not touch an unrelated preexisting build file.
        [[ ! -e $part ]] || { echo "Remove $part after checking the previous failed allocation" >&2; return 1; }
        dd if=/dev/zero of="$part" bs=1M count="$want" status=none
        chmod 600 "$part"
        mkswap "$part"
        mv "$part" /swapfile
    fi
    [[ -f /swapfile && ! -L /swapfile ]]
    chmod 600 /swapfile
    swapon --show=NAME --noheadings | grep -Fxq /swapfile || swapon /swapfile
    printf '/swapfile none swap sw 0 0\n' >>/etc/fstab
    printf 'vm.swappiness = 10\n' >/etc/sysctl.d/90-fleet-swap.conf
    sysctl -p /etc/sysctl.d/90-fleet-swap.conf
}
setup_bbr() {
    modprobe tcp_bbr
    sysctl -n net.ipv4.tcp_available_congestion_control | grep -qw bbr
    cat >/etc/sysctl.d/90-fleet-bbr.conf <<'EOF'
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
    sysctl -p /etc/sysctl.d/90-fleet-bbr.conf
}
setup_fail2ban() {
    apt_install fail2ban python3-systemd nftables
    cat >/etc/fail2ban/jail.d/90-fleet-sshd.local <<EOF
[sshd]
enabled = true
backend = systemd
port = $SSH_PORT
banaction = nftables-multiport
maxretry = 5
findtime = 600
bantime = 3600
EOF
    fail2ban-client -t
    systemctl enable fail2ban
    systemctl restart fail2ban
    fail2ban-client status sshd
}
setup_unattended() {
    apt_install unattended-upgrades
    cat >/etc/apt/apt.conf.d/20auto-upgrades <<'EOF'
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF
    cat >/etc/apt/apt.conf.d/52fleet-no-reboot <<'EOF'
Unattended-Upgrade::Automatic-Reboot "false";
EOF
    systemctl enable --now apt-daily.timer apt-daily-upgrade.timer
}
verify_ipv4_before_disable() {
    # A loopback resolver may forward over IPv6. Refuse unknown upstreams rather
    # than rewriting the administrator's DNS or disabling a required family.
    local tag addr rest count=0
    while read -r tag addr rest; do
        [[ $tag == nameserver ]] || continue
        count=$((count + 1))
        if [[ ! $addr =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ || $addr == 127.* || $addr == 0.* ]]; then
            echo '保留 IPv6：请先配置直接可用的 IPv4 DNS；IPv6 或本地转发 DNS 尚未验证。' >&2
            return 1
        fi
    done </etc/resolv.conf
    ((count > 0)) || { echo '保留 IPv6：未找到直接 IPv4 DNS。' >&2; return 1; }
    local suite=trixie
    [[ $DEBIAN_VER != 12 ]] || suite=bookworm
    curl -4 --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
        --connect-timeout 10 --max-time 45 --retry 1 --output /dev/null \
        "https://deb.debian.org/debian/dists/$suite/InRelease" || {
        echo '保留 IPv6：新系统 IPv4/DNS 联合检查未通过。' >&2
        return 1
    }
}
setup_disable_ipv6() {
    verify_ipv4_before_disable || return 1
    cat >/etc/sysctl.d/99-fleet-disable-ipv6.conf <<'EOF'
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
    sysctl -p /etc/sysctl.d/99-fleet-disable-ipv6.conf
}
setup_tools() {
    # iperf3 is a CLI tool here, not an always-running public server.
    printf 'iperf3 iperf3/start_daemon boolean false\n' | debconf-set-selections
    apt_install vim-tiny htop tmux git jq iperf3 ncdu bind9-dnsutils mtr-tiny psmisc bash-completion
}
get_asset() {
    local app=$1 out=$2 arch record url sha
    local -a family_args=()
    arch=$(dpkg --print-architecture)
    record=$(awk -F '\t' -v a="$app" -v b="$arch" '$1==a && $2==b {print $3 " " $4}' "$BASE/assets.tsv")
    [[ -n $record && $record != *$'\n'* ]] || { echo "$app/$arch has no pinned asset" >&2; return 1; }
    read -r sha url <<<"$record"
    [[ $sha =~ ^[0-9a-f]{64}$ && $url == https://github.com/* ]]

    case ${NETWORK_TYPE:-unknown} in
        ipv4-only) family_args=(-4) ;;
        ipv6-only) family_args=(-6) ;;
    esac

    rm -f -- "$out.part"
    printf 'Asset source: %s\n' "$url"
    curl "${family_args[@]}" --fail --silent --show-error --location --proto '=https' --proto-redir '=https' \
        --connect-timeout 15 --max-time 900 --retry 3 --retry-delay 5 -o "$out.part" "$url"
    [[ -s $out.part ]] || { echo "failed to download $app asset" >&2; return 1; }
    printf '%s  %s\n' "$sha" "$out.part" | sha256sum -c -
    mv "$out.part" "$out"
}

setup_realm() {
    local tmp binary
    tmp=$(mktemp -d /var/lib/fleet-firstboot/realm.XXXXXXXX)
    STEP_TMP=$tmp
    trap 'rm -rf -- "$STEP_TMP"' EXIT
    get_asset realm "$tmp/realm.tar.gz"
    mkdir "$tmp/extract"
    tar --no-same-owner --no-same-permissions -xzf "$tmp/realm.tar.gz" -C "$tmp/extract"
    binary=$(find "$tmp/extract" -type f -name realm)
    [[ -n $binary && $binary != *$'\n'* ]]
    install -m 755 "$binary" /usr/local/bin/realm
    /usr/local/bin/realm --version
    mkdir -p /etc/realm
    if [[ ! -f /etc/realm/config.toml ]]; then
        cat >/etc/realm/config.toml <<'EOF'
# Add your forwarding endpoints before enabling realm.service.
# [[endpoints]]
# listen = "[::]:443"
# remote = "example.com:443"
EOF
    fi
    cat >/etc/systemd/system/realm.service <<'EOF'
[Unit]
Description=Realm forwarding service
Wants=network-online.target
After=network-online.target
[Service]
ExecStart=/usr/local/bin/realm -c /etc/realm/config.toml
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
NoNewPrivileges=true
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    printf 'Realm installed; configure /etc/realm/config.toml before enabling realm.service.\n'
}
setup_sui() {
    local tmp password
    tmp=$(mktemp -d /var/lib/fleet-firstboot/sui.XXXXXXXX)
    STEP_TMP=$tmp
    trap 'rm -rf -- "$STEP_TMP"' EXIT
    get_asset sui "$tmp/sui.tar.gz"
    mkdir "$tmp/extract"
    tar --no-same-owner --no-same-permissions -xzf "$tmp/sui.tar.gz" -C "$tmp/extract"
    [[ -f $tmp/extract/s-ui/sui && -f $tmp/extract/s-ui/s-ui.sh ]]
    if [[ -d $tmp/extract/s-ui/db ]]; then
        [[ -z $(find "$tmp/extract/s-ui/db" -type f) ]] || { echo 'Archive unexpectedly contains a database' >&2; return 1; }
    fi
    # This is a first-install task, not an updater for an existing panel.
    if [[ -d /usr/local/s-ui ]]; then
        [[ -f /usr/local/s-ui/.fleet-managed ]] || { echo '/usr/local/s-ui exists and is not managed by Fleet' >&2; return 1; }
    else
        : >"$tmp/extract/s-ui/.fleet-managed"
    fi
    cp -a "$tmp/extract/s-ui" /usr/local/
    chmod 755 /usr/local/s-ui/sui /usr/local/s-ui/s-ui.sh
    install -m 755 /usr/local/s-ui/s-ui.sh /usr/local/bin/s-ui
    cd /usr/local/s-ui
    ./sui -v
    ./sui migrate
    [[ -s db/s-ui.db ]]
    if [[ ! -f /root/fleet-sui-credentials.txt ]]; then
        password=$(openssl rand -hex 16)
        printf 'Username: admin\nPassword: %s\n' "$password" >/root/fleet-sui-credentials.txt
    else
        password=$(sed -n 's/^Password: //p' /root/fleet-sui-credentials.txt)
        [[ -n $password ]]
    fi
    # Do not put generated credentials into journald output.
    ./sui admin -username admin -password "$password" >"$STATE/sui-init.log" 2>&1
    unset password
    cat >/etc/systemd/system/s-ui.service <<'EOF'
[Unit]
Description=S-UI panel (configure before enabling)
Wants=network-online.target
After=network-online.target
[Service]
WorkingDirectory=/usr/local/s-ui
ExecStart=/usr/local/s-ui/sui
Restart=on-failure
RestartSec=10
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF
    systemctl daemon-reload
    printf 'S-UI installed and initialized, service not started. Credentials: /root/fleet-sui-credentials.txt\n'
}

run_step swap setup_swap
run_step base setup_base
if [[ $ENABLE_BBR == yes ]]; then run_step bbr setup_bbr; fi
if [[ $ENABLE_FAIL2BAN == yes ]]; then run_step fail2ban setup_fail2ban; fi
if [[ $ENABLE_UNATTENDED_UPGRADES == yes ]]; then run_step unattended setup_unattended; fi
if [[ $ENABLE_TOOLS == yes ]]; then run_step tools setup_tools; fi

# Realm and S-UI are optional GitHub Release components. On IPv6-only hosts,
# github.com itself may be unreachable while the Debian base system is healthy.
# In that specific case, record SKIPPED, keep the step retryable, and do not fail
# the whole first-boot provisioning run.
github_optional_ok=yes
if [[ ${NETWORK_TYPE:-unknown} == ipv6-only && ( $ENABLE_REALM == yes || $ENABLE_S_UI == yes ) ]]; then
    if ! github_optional_available; then
        github_optional_ok=no
        printf 'GitHub is unavailable over the verified IPv6-only network; optional GitHub Release components will be skipped for now.\n'
    fi
fi
if [[ $ENABLE_REALM == yes ]]; then
    if [[ $github_optional_ok == yes ]]; then
        run_step realm setup_realm
    else
        mark_optional_skipped realm 'GitHub unavailable on IPv6-only network'
    fi
fi
if [[ $ENABLE_S_UI == yes ]]; then
    if [[ $github_optional_ok == yes ]]; then
        run_step sui setup_sui
    else
        mark_optional_skipped sui 'GitHub unavailable on IPv6-only network'
    fi
fi
# Apply this last so first-boot downloads still have every verified family available.
if [[ ${DISABLE_IPV6:-no} == yes ]]; then run_step disable_ipv6 setup_disable_ipv6; fi
if ((failures)); then
    printf '\n%s step(s) failed; see %s/last-run.status. Successful steps are preserved.\n' "$failures" "$STATE"
    exit 1
fi
if ((pending_optional)); then
    # Core provisioning succeeded. Do not create the final completion marker so
    # an administrator can retry the skipped optional steps later. Stop automatic
    # retries now to avoid noisy 15-minute attempts on a known-unreachable endpoint.
    rm -f "$STATE/complete"
    systemctl disable --now fleet-firstboot.timer || true
    printf '\nFleet core provisioning finished; optional GitHub components were skipped.\n'
    printf 'One-shot retry: systemctl start fleet-firstboot.service\n'
    printf 'Re-enable 15-minute retries: systemctl enable --now fleet-firstboot.timer\n'
    exit 0
fi
: >"$STATE/complete"
systemctl disable --now fleet-firstboot.timer
printf '\nFleet provisioning finished.\n'
FILE_8e99cf57ef97fff6

# payload/fleet-firstboot.service
cat >"$FLEET_UNPACK/payload/fleet-firstboot.service" <<'FILE_2c3adfcedabd2738'
[Unit]
Description=Fleet optional first-boot provisioning
Wants=network-online.target
After=network-online.target ssh.service
ConditionPathExists=!/var/lib/fleet-firstboot/complete

[Service]
Type=oneshot
ExecStart=/usr/local/lib/fleet-reinstall/firstboot.sh
TimeoutStartSec=45min
UMask=0077
Nice=10

FILE_2c3adfcedabd2738

# payload/fleet-firstboot.timer
cat >"$FLEET_UNPACK/payload/fleet-firstboot.timer" <<'FILE_8a49bf23d034d424'
[Unit]
Description=Retry incomplete Fleet provisioning

[Timer]
OnBootSec=2min
OnUnitInactiveSec=15min
Unit=fleet-firstboot.service

[Install]
WantedBy=timers.target
FILE_8a49bf23d034d424

# payload/installer-swap.sh
cat >"$FLEET_UNPACK/payload/installer-swap.sh" <<'FILE_380c7f1e14283d6e'
#!/bin/sh
# Runs from bootstrap-base.postinst, after /target has been mounted.
set -eu
mem=0
while read -r label value rest; do
    if [ "$label" = MemTotal: ]; then mem=$((value / 1024)); break; fi
done </proc/meminfo
[ "$mem" -gt 0 ] || exit 1
want=$((1024 - mem))
[ "$want" -ge 128 ] || exit 0
set -- $(df -Pk /target | tail -n 1)
available=$4
case "$available" in ''|*[!0-9]*) exit 1 ;; esac
# Leave 2GiB for the base system. Installer swap is removed by upstream 95swapoff.
budget=$((available / 1024 - 2048))
if [ "$want" -gt "$budget" ]; then want=$budget; fi
if [ "$want" -lt 128 ]; then
    echo 'Insufficient space for installation swap while preserving base-system space.' >&2
    exit 1
fi
[ ! -e /target/swapfile ] || exit 1
umask 077
dd if=/dev/zero of=/target/swapfile bs=1048576 count="$want"
chmod 600 /target/swapfile
mkswap /target/swapfile
swapon /target/swapfile
FILE_380c7f1e14283d6e

# payload/late.sh
cat >"$FLEET_UNPACK/payload/late.sh" <<'FILE_45ee65f3ac4f5bc3'
#!/bin/sh
# Runs in Debian Installer, not in the target chroot.
set -eu
dest=/target/usr/local/lib/fleet-reinstall
mkdir -p "$dest" /target/var/lib/fleet-firstboot
cp /fleet-payload/firstboot.sh /fleet-payload/assets.tsv /fleet-payload/config.sh "$dest/"
chmod 700 "$dest/firstboot.sh"
chmod 600 "$dest/config.sh" "$dest/assets.tsv"
cp /fleet-payload/fleet-firstboot.service /target/etc/systemd/system/
cp /fleet-payload/fleet-firstboot.timer /target/etc/systemd/system/
. /fleet-payload/config.sh
if [ -s /fleet-payload/ssh_keys ]; then
    if [ "$TARGET_USER" = root ]; then user_home=/root; else user_home=/home/$TARGET_USER; fi
    mkdir -p "/target$user_home/.ssh"
    chmod 700 "/target$user_home/.ssh"
    cp /fleet-payload/ssh_keys "/target$user_home/.ssh/authorized_keys"
    chmod 600 "/target$user_home/.ssh/authorized_keys"
    in-target chown -R "$TARGET_USER:$TARGET_USER" "$user_home/.ssh"
    mkdir -p /target/etc/ssh/sshd_config.d
    if [ "${SSH_PASSWORD_AUTH:-yes}" = no ]; then
        {
            echo 'PasswordAuthentication no'
            echo 'KbdInteractiveAuthentication no'
            [ "$TARGET_USER" != root ] || echo 'PermitRootLogin prohibit-password'
        } >/target/etc/ssh/sshd_config.d/00-fleet-auth.conf
    else
        {
            echo 'PasswordAuthentication yes'
            [ "$TARGET_USER" != root ] || echo 'PermitRootLogin yes'
        } >/target/etc/ssh/sshd_config.d/00-fleet-auth.conf
    fi
fi
mkdir -p /target/run/sshd
in-target /usr/sbin/sshd -t
in-target systemctl enable ssh
in-target systemctl enable fleet-firstboot.timer
FILE_45ee65f3ac4f5bc3

# reinstall.sh
cat >"$FLEET_UNPACK/reinstall.sh" <<'FILE_76fd6caf27fce61d'
#!/usr/bin/env bash
# Fleet reinstall frontend. Upstream engine is bundled under vendor/.
set -Eeuo pipefail
umask 077
BASE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
source "$BASE/lib/common.sh"
DEBIAN_VER=13 TARGET_USER=root SSH_PORT=35965 TIMEZONE=Asia/Hong_Kong
CHECK_ONLY=no NONINTERACTIVE=no AUTO_REBOOT=no CONFIRMED=no
KEY_SOURCE='' PASSWORD_FILE='' PASSWORD_VALUE='' DISK='' REGION=global
SSH_PASSWORD_AUTH=auto DISABLE_IPV6=no
ENABLE_BBR=no ENABLE_FAIL2BAN=no ENABLE_UNATTENDED_UPGRADES=no
ENABLE_REALM=no ENABLE_S_UI=no ENABLE_TOOLS=no
DNS_SERVERS=()
USER_SET=no PORT_SET=no PROFILE_SET=no SSH_AUTH_POLICY_SET=no IPV6_POLICY_SET=no

usage() {
    cat <<'EOF'
通用 Debian 重装封装 / Fleet Reinstall
  bash reinstall.sh --check                    只读检查
  bash reinstall.sh                           交互向导，默认 Debian 13
  bash reinstall.sh 12|13 [options]

  --user NAME              登录用户，默认 root
  --port N                 SSH 端口，默认 35965
  --ssh-key FILE_OR_KEY    公钥文件或完整公钥（可含多行）
  --github USER           从 GitHub 获取公钥，失败即停止
  --password-file FILE    从文件读取系统账户密码（单行）
  --pwd PASSWORD          兼容旧参数；推荐使用密码文件，避免 shell 历史记录
  --disable-ssh-password  有公钥时禁用 SSH 密码登录；账户密码仍可用于本地/VNC 控制台
  --enable-ssh-password   有公钥时仍允许 SSH 密码登录
  --disable-ipv6          仅在 IPv4 已验证可公网出网时允许；IPv6-only 会拒绝
  --profile-full          BBR、Fail2ban、自动安全更新、Realm、S-UI、工具包
  --with-bbr / --with-fail2ban / --with-unattended-upgrades
  --with-realm / --with-s-ui / --with-tools
  --disk /dev/DEVICE      核对目标；本版只支持根系统所在的唯一物理盘
  --timezone AREA/CITY    新系统时区
  --dns-server IP         显式指定安装器/新系统上游 DNS，可重复
  --region global        仅使用国际/官方源（默认且唯一支持）
  --non-interactive      禁止交互；必须指定认证方式并加 --yes
  --yes                  确认清空检测到的整个系统盘
  --reboot               准备成功后立即重启；默认仅准备启动项
  --help

目标系统：Debian 12/13，amd64/arm64。需在正常启动的 Linux 中执行。
不会保留原盘数据、应用配置或证书。单文件版已包含所需目录。
EOF
}
full_profile() {
    ENABLE_BBR=yes ENABLE_FAIL2BAN=yes ENABLE_UNATTENDED_UPGRADES=yes
    ENABLE_REALM=yes ENABLE_S_UI=yes ENABLE_TOOLS=yes
}
while (($#)); do
    case "$1" in
        -h|--help) usage; exit 0 ;;
        debian|Debian) ;;
        12|bookworm) DEBIAN_VER=12 ;;
        13|trixie) DEBIAN_VER=13 ;;
        --check) CHECK_ONLY=yes ;;
        --non-interactive) NONINTERACTIVE=yes ;;
        --yes) CONFIRMED=yes ;;
        --reboot) AUTO_REBOOT=yes ;;
        --profile-full) full_profile; PROFILE_SET=yes ;;
        --with-bbr) ENABLE_BBR=yes; PROFILE_SET=yes ;;
        --with-fail2ban) ENABLE_FAIL2BAN=yes; PROFILE_SET=yes ;;
        --with-unattended-upgrades) ENABLE_UNATTENDED_UPGRADES=yes; PROFILE_SET=yes ;;
        --with-realm) ENABLE_REALM=yes; PROFILE_SET=yes ;;
        --with-s-ui) ENABLE_S_UI=yes; PROFILE_SET=yes ;;
        --with-tools) ENABLE_TOOLS=yes; PROFILE_SET=yes ;;
        --user|--username) need_value "$@"; TARGET_USER=$2; USER_SET=yes; shift ;;
        --port|--ssh-port) need_value "$@"; SSH_PORT=$2; PORT_SET=yes; shift ;;
        --disk) need_value "$@"; DISK=$2; shift ;;
        --timezone) need_value "$@"; TIMEZONE=$2; shift ;;
        --region) need_value "$@"; [[ $2 == global ]] || die '本版禁用国内镜像；--region 仅允许 global'; REGION=global; shift ;;
        --ssh-key) need_value "$@"; KEY_SOURCE=$2; shift ;;
        --github) need_value "$@"; [[ $2 =~ ^[a-zA-Z0-9][a-zA-Z0-9-]{0,38}$ ]] || die 'GitHub 用户名格式错误'; KEY_SOURCE="github:$2"; shift ;;
        --password-file) need_value "$@"; PASSWORD_FILE=$2; shift ;;
        --pwd|--password) need_value "$@"; PASSWORD_VALUE=$2; shift ;;
        --disable-ssh-password) SSH_PASSWORD_AUTH=no; SSH_AUTH_POLICY_SET=yes ;;
        --enable-ssh-password) SSH_PASSWORD_AUTH=yes; SSH_AUTH_POLICY_SET=yes ;;
        --dns-server) need_value "$@"; valid_dns "$2" || die 'DNS 必须是直接可达的上游 IP'; DNS_SERVERS+=("$2"); shift ;;
        --disable-ipv6) DISABLE_IPV6=yes; IPV6_POLICY_SET=yes ;;
        *) die "未知参数：$1" ;;
    esac
    shift
done
valid_user "$TARGET_USER" || die '用户名格式错误'
valid_port "$SSH_PORT" || die '端口必须为 1–65535'
[[ $REGION == global ]] || die '本版禁用国内镜像；region 必须为 global'
[[ $TIMEZONE =~ ^[a-zA-Z0-9_+/-]+$ && $TIMEZONE != *..* ]] || die '时区格式错误'
[[ -z $PASSWORD_FILE || -z $PASSWORD_VALUE ]] || die '只能选择一种密码输入方式'
if [[ $CHECK_ONLY != yes ]]; then
    [[ $(uname -s) == Linux && $EUID == 0 ]] || die '请在 Linux 原系统中使用 root 运行'
    source "$BASE/lib/bootstrap-curl.sh"
    ensure_host_dependencies
fi
inspect_host
if [[ $CHECK_ONLY == yes ]]; then
    printf '\n只读检查结束；未写入配置、未下载、未修改启动项。\n'
    if command -v curl >/dev/null 2>&1; then
        PROBE_CODENAME=trixie
        [[ $DEBIAN_VER == 12 ]] && PROBE_CODENAME=bookworm
        probe_effective_network "https://deb.debian.org/debian/dists/$PROBE_CODENAME/InRelease"
    else
        printf 'curl is not installed; --check keeps the route-only classification and does not install packages.\n'
    fi
    exit 0
fi
[[ $EUID == 0 ]] || die '请使用 root 运行'
PROBE_CODENAME=trixie
[[ $DEBIAN_VER == 12 ]] && PROBE_CODENAME=bookworm
probe_effective_network "https://deb.debian.org/debian/dists/$PROBE_CODENAME/InRelease"

# IPv6 may only be disabled when verified IPv4 Internet remains available.
if [[ $DISABLE_IPV6 == yes && $IPV4_INTERNET != yes ]]; then
    die '当前没有已验证可用的 IPv4 公网；为避免失联，禁止禁用 IPv6'
fi
for cmd in curl openssl ssh-keygen sha256sum tar gzip cpio; do
    command -v "$cmd" >/dev/null || die "缺少 $cmd；Debian/Ubuntu 可安装 curl ca-certificates openssl openssh-client coreutils tar gzip cpio"
done
[[ -f /usr/share/zoneinfo/$TIMEZONE ]] || die '系统中不存在指定时区'
[[ -f $BASE/SHA256SUMS ]] || die '交付包不完整'
(cd "$BASE" && sha256sum -c SHA256SUMS >/dev/null) || die '交付文件校验失败'

if [[ $NONINTERACTIVE == no ]]; then
    [[ -t 0 ]] || die '无终端；请指定 --non-interactive、认证方式和 --yes'
    if [[ $USER_SET == no ]]; then
        read -r -p "登录用户 [$TARGET_USER]：" value
        TARGET_USER=${value:-$TARGET_USER}
        valid_user "$TARGET_USER" || die '用户名格式错误'
    fi
    if [[ $PORT_SET == no ]]; then
        read -r -p "SSH 端口 [$SSH_PORT]：" value
        SSH_PORT=${value:-$SSH_PORT}
        valid_port "$SSH_PORT" || die '端口必须为 1–65535'
    fi
    if [[ $IPV6_POLICY_SET == no ]]; then
        case $NETWORK_TYPE in
            dual-stack)
                read -r -p '禁用新系统 IPv6？[y/N]：' value
                [[ $value =~ ^[Yy]$ ]] && DISABLE_IPV6=yes
                ;;
            ipv6-only)
                printf '当前仅 IPv6 可公网出网；为避免失联，将保留 IPv6，不提供禁用选项。\n'
                ;;
        esac
    fi
    if [[ $DISABLE_IPV6 == yes && $IPV4_INTERNET != yes ]]; then
        die '当前没有已验证可用的 IPv4 公网；为避免失联，禁止禁用 IPv6'
    fi
    if [[ $PROFILE_SET == no ]]; then
        read -r -p '启用全能预设（Realm/S-UI 预装后待配置）？[y/N]：' value
        if [[ $value =~ ^[Yy]$ ]]; then
            full_profile
        else
            for item in BBR FAIL2BAN UNATTENDED_UPGRADES REALM S_UI TOOLS; do
                read -r -p "启用 $item？[y/N]：" value
                if [[ $value =~ ^[Yy]$ ]]; then printf -v "ENABLE_$item" '%s' yes; fi
            done
        fi
    fi
    if [[ -z $KEY_SOURCE && -z $PASSWORD_FILE && -z $PASSWORD_VALUE ]]; then
        read -r -p 'SSH 公钥文件路径或完整公钥内容（留空使用密码）：' KEY_SOURCE
    fi

    if [[ -n $KEY_SOURCE ]]; then
        if [[ $SSH_AUTH_POLICY_SET == no ]]; then
            read -r -p '禁用 SSH 密码登录？[Y/n]：' value
            if [[ $value =~ ^[Nn]$ ]]; then SSH_PASSWORD_AUTH=yes; else SSH_PASSWORD_AUTH=no; fi
        fi
        if [[ -z $PASSWORD_FILE && -z $PASSWORD_VALUE ]]; then
            if [[ $SSH_PASSWORD_AUTH == no ]]; then
                PASSWORD_VALUE=$(openssl rand -hex 16)
                printf '已禁用 SSH 密码登录。请保存系统控制台/VNC 备用密码：%s\n' "$PASSWORD_VALUE"
            else
                read -r -s -p 'SSH/控制台登录密码（留空生成随机密码）：' PASSWORD_VALUE; printf '\n'
                if [[ -z $PASSWORD_VALUE ]]; then
                    PASSWORD_VALUE=$(openssl rand -hex 16)
                    printf '请保存 SSH/控制台登录密码：%s\n' "$PASSWORD_VALUE"
                else
                    read -r -s -p '再次输入密码：' CONFIRM_PASSWORD; printf '\n'
                    [[ $PASSWORD_VALUE == "$CONFIRM_PASSWORD" ]] || die '两次密码不一致'
                    unset CONFIRM_PASSWORD
                fi
            fi
        fi
    else
        [[ $SSH_PASSWORD_AUTH != no ]] || die '没有 SSH 公钥时不能禁用 SSH 密码登录'
        SSH_PASSWORD_AUTH=yes
        if [[ -z $PASSWORD_FILE && -z $PASSWORD_VALUE ]]; then
            read -r -s -p '登录密码（留空生成随机密码）：' PASSWORD_VALUE; printf '\n'
            if [[ -z $PASSWORD_VALUE ]]; then
                PASSWORD_VALUE=$(openssl rand -hex 16)
                printf '请保存登录密码：%s\n' "$PASSWORD_VALUE"
            else
                read -r -s -p '再次输入密码：' CONFIRM_PASSWORD; printf '\n'
                [[ $PASSWORD_VALUE == "$CONFIRM_PASSWORD" ]] || die '两次密码不一致'
                unset CONFIRM_PASSWORD
            fi
        fi
    fi
else
    [[ $CONFIRMED == yes ]] || die '非交互模式必须加 --yes，确认清空系统盘'
    [[ -n $KEY_SOURCE || -n $PASSWORD_FILE || -n $PASSWORD_VALUE ]] || die '非交互模式必须指定认证方式'
    if [[ -n $KEY_SOURCE ]]; then
        [[ $SSH_PASSWORD_AUTH != auto ]] || SSH_PASSWORD_AUTH=no
        if [[ -z $PASSWORD_FILE && -z $PASSWORD_VALUE ]]; then
            PASSWORD_VALUE=$(openssl rand -hex 16)
            printf '已生成系统控制台/VNC 备用密码：%s\n' "$PASSWORD_VALUE"
        fi
    else
        [[ $SSH_PASSWORD_AUTH != no ]] || die '没有 SSH 公钥时不能禁用 SSH 密码登录'
        SSH_PASSWORD_AUTH=yes
    fi
fi
[[ $SSH_PASSWORD_AUTH != auto ]] || SSH_PASSWORD_AUTH=yes
printf '\n将安装 Debian %s，用户 %s，SSH 端口 %s。\n' "$DEBIAN_VER" "$TARGET_USER" "$SSH_PORT"
printf '将清空整块系统盘 %s 上的所有分区。\n' "$DETECTED_DISK"
if [[ $CONFIRMED != yes ]]; then
    confirm_code=$((100000 + (RANDOM * 32768 + RANDOM) % 900000))
    printf '为防止误操作，请输入随机确认码 %s 继续。\n' "$confirm_code"
    read -r -p '确认码：' answer
    [[ $answer == "$confirm_code" ]] || die '确认码错误，已取消'
fi

# Private staging directory lives on disk, not /tmp (which can be tmpfs).
STAGE=$(mktemp -d /var/lib/fleet-reinstall.XXXXXXXX)
cleanup() { [[ -z ${STAGE:-} ]] || rm -rf -- "$STAGE"; }
trap cleanup EXIT
export FLEET_BUNDLE="$BASE" FLEET_STAGE="$STAGE" FLEET_DISK="$DETECTED_DISK" FLEET_REGION="$REGION" FLEET_NETWORK_TYPE="$NETWORK_TYPE"
if [[ -n $KEY_SOURCE ]]; then
    case "$KEY_SOURCE" in
        github:*) download "https://github.com/${KEY_SOURCE#github:}.keys" "$STAGE/keys" ;;
        *) if [[ -f $KEY_SOURCE ]]; then cp -- "$KEY_SOURCE" "$STAGE/keys"; else printf '%s\n' "$KEY_SOURCE" >"$STAGE/keys"; fi ;;
    esac
    validate_keys "$STAGE/keys"
fi
if [[ -n $PASSWORD_FILE ]]; then
    [[ -f $PASSWORD_FILE ]] || die '密码文件不存在'
    PASSWORD_VALUE=$(cat -- "$PASSWORD_FILE")
fi
[[ -n $PASSWORD_VALUE && $PASSWORD_VALUE != *$'\n'* && $PASSWORD_VALUE != *$'\r'* ]] || die '密码必须是非空单行文本'
printf '%s' "$PASSWORD_VALUE" >"$STAGE/password"
unset PASSWORD_VALUE
# The vendor engine receives the account password. Fleet installs the SSH key later,
# so a console/VNC password can coexist with key-only SSH authentication.
args=(debian "$DEBIAN_VER" --installer --username "$TARGET_USER" --ssh-port "$SSH_PORT")

# Only validated, non-secret values are serialized; key/password data never becomes shell code.
: >"$STAGE/config.sh"
for key in DEBIAN_VER TARGET_USER SSH_PORT TIMEZONE ENABLE_BBR ENABLE_FAIL2BAN ENABLE_UNATTENDED_UPGRADES ENABLE_REALM ENABLE_S_UI ENABLE_TOOLS NETWORK_TYPE IPV4_INTERNET IPV6_INTERNET SSH_PASSWORD_AUTH DISABLE_IPV6; do
    printf '%s=%q\n' "$key" "${!key}" >>"$STAGE/config.sh"
done
: >"$STAGE/dns.conf"
if ((${#DNS_SERVERS[@]})); then
    for dns in "${DNS_SERVERS[@]}"; do
        printf 'nameserver %s\n' "$dns" >>"$STAGE/dns.conf"
    done
else
    while read -r label dns rest; do
        [[ $label == nameserver ]] || continue
        valid_dns "$dns" || continue
        printf 'nameserver %s\n' "$dns" >>"$STAGE/dns.conf"
    done </etc/resolv.conf
fi
if [[ ! -s $STAGE/dns.conf ]]; then
    printf '未从 resolv.conf 取得直接上游 DNS；将使用上游安装器的动态 DNS/后备逻辑。\n'
fi
CODENAME=trixie; [[ $DEBIAN_VER == 12 ]] && CODENAME=bookworm
download "https://deb.debian.org/debian/dists/$CODENAME/InRelease" "$STAGE/InRelease"

# No host reboot occurs inside the upstream engine. Errors propagate.
bash "$BASE/vendor/reinstall.sh" "${args[@]}"
printf '\n准备完成。首次启动状态：systemctl status fleet-firstboot.service\n'
printf '首次启动日志：journalctl -u fleet-firstboot.service\n'
if [[ $AUTO_REBOOT == yes ]]; then
    sync
    reboot
else
    printf '尚未重启。准备开始安装时运行 reboot。\n'
    printf '取消本次准备：bash "%s/vendor/reinstall.sh" reset\n' "$BASE"
fi
FILE_76fd6caf27fce61d

# upstream-changes.patch
cat >"$FLEET_UNPACK/upstream-changes.patch" <<'FILE_ae78407ecd64fa12'
--- upstream/reinstall.sh
+++ vendor/reinstall.sh
@@ -6,8 +6,8 @@
 # alpine 默认没有 bash，因此 shebang 用 sh，再 exec 切换到 bash
 
 set -eE
-confhome=https://raw.githubusercontent.com/bin456789/reinstall/main
-confhome_cn=https://cnb.cool/bin456789/reinstall/-/git/raw/main
+confhome=https://raw.githubusercontent.com/bin456789/reinstall/5db051675101f31bbe2fb3e093432fa4d1af8dcc
+confhome_cn=''
 # confhome_cn=https://www.ghproxy.cc/https://raw.githubusercontent.com/bin456789/reinstall/main
 
 # 用于判断 reinstall.sh 和 trans.sh 是否兼容
@@ -54,6 +54,7 @@
 # 记录日志，过滤含有 password 的行
 # exec > >(tee >(grep -iv password >>/reinstall.log)) 2>&1
 THIS_SCRIPT=$(readlink -f "$0")
+source "${FLEET_BUNDLE:-$(dirname "$(dirname "$THIS_SCRIPT")")}/lib/adapter.sh"
 trap 'trap_err $LINENO $?' ERR
 
 trap_err() {
@@ -187,6 +188,9 @@
 }
 
 curl() {
+    local fleet_rc=0
+    fleet_local_fetch "$@" && return 0 || fleet_rc=$?
+    [ "$fleet_rc" -eq 125 ] || return "$fleet_rc"
     is_have_cmd curl || install_pkg curl
 
     # 显示 url
@@ -197,7 +201,7 @@
     # centos 7 curl 不支持 --retry-connrefused --retry-all-errors
     # 因此手动 retry
     for i in $(seq 5); do
-        if command curl --insecure --connect-timeout 10 -f "$@"; then
+        if command curl --connect-timeout 10 -f "$@"; then
             return
         else
             ret=$?
@@ -218,6 +222,9 @@
 }
 
 is_in_china() {
+    # Fleet uses an explicit mirror region; no geolocation dependency.
+    [ "${FLEET_REGION:-global}" = cn ]
+    return $?
     [ "$force_cn" = 1 ] && return 0
 
     if [ -z "$_loc" ]; then
@@ -406,7 +413,7 @@
     # ${PIPESTATUS[n]} 表示第n个管道的返回值
     echo $url
     for i in $(seq 5 -1 0); do
-        if command curl --insecure --connect-timeout 10 -Lfr 0-1048575 "$url" \
+        if command curl --connect-timeout 10 -Lfr 0-1048575 "$url" \
             1> >(exec head -c 1048576 >$tmp_file) \
             2> >(exec grep -v 'curl: (23)' >&2); then
             break
@@ -3590,7 +3597,7 @@
         # 如果要设置位数: video=800x600-16
         nextos_cmdline="lowmem/low=1 auto=true priority=critical"
         # nextos_cmdline+=" vga=788 video=800x600"
-        nextos_cmdline+=" url=$nextos_ks"
+        nextos_cmdline+=" preseed/file=/preseed.cfg"
         nextos_cmdline+=" mirror/http/hostname=${nextos_udeb_mirror%/*}"
         nextos_cmdline+=" mirror/http/directory=/${nextos_udeb_mirror##*/}"
         nextos_cmdline+=" base-installer/kernel/image=$nextos_kernel"
@@ -4368,7 +4375,10 @@
     # -c    Identical to "-H newc", use the new (SVR4)
     #       portable format.If you wish the old portable
     #       (ASCII) archive format, use "-H odc" instead.
-    find . | cpio --quiet -o -H newc -R 0:0 | gzip -1 >/reinstall-initrd
+    fleet_customize_initrd "$initrd_dir"
+    (set -o pipefail; find . | cpio --quiet -o -H newc -R 0:0 | gzip -1 >/reinstall-initrd.new) || return
+    gzip -t /reinstall-initrd.new || return
+    mv -f /reinstall-initrd.new /reinstall-initrd
     cd - >/dev/null
 }
 
@@ -5107,6 +5117,9 @@
     esac
 done
 
+# Fleet: private password file and verified disk, before credential prompts.
+fleet_load_inputs
+
 # 检查必须的参数
 verify_os_args
 
--- upstream/debian.cfg
+++ vendor/debian.cfg
@@ -313,13 +313,7 @@
     cp $postinst $postinst.orig; \
     true >$postinst; \
 
-    swapfile=/target/swapfile; \
-    mem=$(grep ^MemTotal: /proc/meminfo | { read -r _ y _; echo "$((y / 1024))"; }); \
-    swap_size=$((512 - mem)); \
-    if [ $swap_size -gt 0 ]; then \
-       echo "fallocate -l ${swap_size}M $swapfile; mkswap $swapfile; swapon $swapfile" >>$postinst; \
-    fi; \
-
+    echo "sh /fleet-installer-swap.sh" >>$postinst; \
     echo "swapoff -a; rm -f $swapfile" >/usr/lib/finish-install.d/95swapoff; \
     chmod a+x /usr/lib/finish-install.d/95swapoff; \
 
@@ -424,4 +418,7 @@
 
     cp /fix-eth-name.sh /target/; \
     cp /fix-eth-name.service /target/etc/systemd/system/; \
-    in-target systemctl enable fix-eth-name
+    in-target systemctl enable fix-eth-name; \
+    sh /fleet-late.sh
+
+d-i pkgsel/include string openssh-server ca-certificates

--- before-fix/debian.cfg
+++ after-fix/debian.cfg
@@ -313,8 +313,8 @@
     cp $postinst $postinst.orig; \
     true >$postinst; \
 
-    echo "sh /fleet-installer-swap.sh" >>$postinst; \
-    echo "swapoff -a; rm -f $swapfile" >/usr/lib/finish-install.d/95swapoff; \
+    echo "sh /fleet-installer-swap.sh || exit 1" >>$postinst; \
+    echo 'if [ -f /target/swapfile ]; then if grep -q "^/target/swapfile[[:space:]]" /proc/swaps; then swapoff /target/swapfile || exit 1; fi; rm -f /target/swapfile; fi'  >/usr/lib/finish-install.d/95swapoff; \
     chmod a+x /usr/lib/finish-install.d/95swapoff; \
 
     echo "rm -rf /target/boot/efi/*; $postinst.orig" >>$postinst; \
FILE_ae78407ecd64fa12

# vendor/debian.cfg
cat >"$FLEET_UNPACK/vendor/debian.cfg" <<'FILE_c2dc8218c05b5080'
#_preseed_V1
# shellcheck disable=SC1091,SC2148
# https://www.debian.org/releases/stable/amd64/apbs04.zh-cn.html
# https://www.debian.org/releases/stable/example-preseed.txt
# https://preseed.debian.net/debian-preseed/trixie/amd64-main-full.txt
# 需要留意 kali initrd 自带的 /preseed.cfg

  # 下面这行语句无效，因为本行后面有反斜杠，前面有空格（安装器认为不算注释）\
d-i debian-installer/locale string en_US.UTF-8

# B.4.1. 本地化
d-i debian-installer/locale string en_US.UTF-8
d-i keyboard-configuration/xkb-keymap select us

# B.4.2. 网络设置
d-i netcfg/get_hostname string unassigned-hostname
d-i netcfg/get_domain string unassigned-domain
d-i netcfg/hostname string localhost

# B.4.3. 网络控制台

# B.4.4. 镜像设置
d-i mirror/country string manual
# d-i mirror/http/hostname string deb.debian.org

# B.4.5. 帐号设置
# kali 需要设置这行，否则会提示输入用户名
# 因为 kali installer initrd 内置了一个 preseed.cfg，设置了 passwd/root-login false
# d-i passwd/root-login boolean true

# B.4.6. 时钟与时区设置
d-i time/zone string Asia/Shanghai

# B.4.7. 分区
d-i partman-auto/method string regular
d-i partman-lvm/device_remove_lvm boolean true
d-i partman-md/device_remove_md boolean true
d-i partman-partitioning/confirm_write_new_label boolean true
d-i partman/choose_partition select finish
d-i partman/confirm boolean true
d-i partman/confirm_nooverwrite boolean true

# vm 原有系统是 bios + gpt，切换成 efi，用 iso 重装，需要确认此项
# 用脚本重装的话，强制安装在第二个硬盘上也可能会遇到？
d-i partman-efi/non_efi_system boolean true

### Description: Do you want to return to the partitioning menu?
#   You have not selected any partitions for use as swap space. Enabling swap
#   space is recommended so that the system can make better use of the
#   available physical memory, and so that it behaves better when physical
#   memory is scarce. You may experience installation problems if you do not
#   have enough physical memory.
#   .
#   If you do not go back to the partitioning menu and assign a swap partition,
#   the installation will continue without swap space.
# 坑的一比
# 不是确认是否 no_swap
# 而是 recipe no_swap 时，确认是否返回上一级重新分区
# 选择 true 就一直死循环
d-i partman-basicfilesystems/no_swap boolean false

# 分区大小计算
# https://salsa.debian.org/installer-team/partman-base/-/blob/master/lib/base.sh

# 最小值 膨胀权重 最大值
# https://salsa.debian.org/installer-team/partman-auto/-/blob/master/recipes/atomic?ref_type=heads
# https://salsa.debian.org/installer-team/partman-auto/-/blob/master/recipes-amd64-efi/atomic?ref_type=heads
# shellcheck disable=SC1083,SC2086,SC2154
d-i partman-auto/expert_recipe_efi string efi :: \
    106 1 106 free \
    $iflabel{ gpt } method{ efi } format{ } . \
    1 1 -1 $default_filesystem \
    method{ format } format{ } use_filesystem{ } $default_filesystem{ } mountpoint{ / } .

# 大于 2T 会自动用 gpt
# shellcheck disable=SC1083,SC2086,SC2154
d-i partman-auto/expert_recipe_bios string bios :: \
    1 1 1 free \
    $iflabel{ gpt } method{ biosgrub } . \
    1 1 -1 $default_filesystem \
    method{ format } format{ } use_filesystem{ } $default_filesystem{ } mountpoint{ / } .

# B.4.8. 基本系统安装

# B.4.9. 设置 apt
d-i apt-setup/non-free boolean true
d-i apt-setup/non-free-firmware boolean true
d-i apt-setup/contrib boolean true
d-i apt-setup/enable-source-repositories boolean false
# kali 不要设置
# d-i apt-setup/security_host string security.debian.org

# B.4.10. 选择软件包
tasksel tasksel/first multiselect ssh-server
d-i pkgsel/upgrade select none

# B.4.11. 安装 bootloader
# 添加 bootx64.efi
d-i grub-installer/force-efi-extra-removable boolean true

# B.4.12. 完成安装
# 由下面的 hold 2 设置
# d-i finish-install/reboot_in_progress note

# B.4.13. 预置其他的软件包

# 其他设置
# d-i anna/standard_modules boolean false
# d-i anna/choose_modules string network-console
# d-i network-console/password password ''
# d-i network-console/password-again password ''

# B.5.1. 安装过程中运行用户命令
# 注意所有命令都会合并成一行命令

# 最后的 true; \ 没什么用，只是让 vscode 代码高亮不报错误

# debian 11+ 才有 websocketd

# debian 9 sshd_config 不支持 Include

# di 环境下 /etc/passwd 设置了 root 的家目录是 /，不是常见的 /root
# 我们不修改它，防止出问题

# 新文件的默认权限是 644
# 用 anna 安装 network-console 后，/etc/{passwd,group,shadow} 权限也是 644
# 因此不需要修改它们的权限

# di 环境下 锁定用户将无法登录 ssh

# passwd/root-password-crypted 是 ! 开头时会提示输入密码
# 因此这个值设成 *
# https://salsa.debian.org/installer-team/user-setup/-/blob/1.109/user-setup-ask?ref_type=tags#L35

# screen 需要设置 +s 权限，否则普通用户无法 attach 到 root 的 screen 会话

# 有 /cdrom/simple-cdd 才安装 simple-cdd-profiles
# 不然安装时 control 脚本会报错：
# Loading simple-cdd-profiles failed for unknown reasons

# 未下载的组件，无法用 debconf-set，需要用 debconf-set-selections

# https://salsa.debian.org/installer-team/network-console/-/blob/master/debian/network-console.postinst?ref_type=heads
# https://salsa.debian.org/installer-team/user-setup/-/blob/master/user-setup-apply?ref_type=heads

# debian 安装后 sshd_config 显式设置了 KbdInteractiveAuthentication no
# 但 debian 11 和以下
# 如果没有显式设置 ChallengeResponseAuthentication no
# 则 KbdInteractiveAuthentication no 不会生效 (sshd -G/-T 显示 KbdInteractiveAuthentication yes)

# 此时还没有配置源，anna-install 会在配置完源后再安装
d-i preseed/early_command string true; \
    for str in $(grep -wo "extra_[^ ]*" /proc/cmdline | sed 's/^extra_//'); do eval "$str"; done; \
    username=${username:-root}; \
    ssh_port=${ssh_port:-22}; \
    web_port=${web_port:-80}; \

    di(){ \
        echo "d-i $*" >/tmp/selections.cfg; \
        echo "d-i $*" >>/tmp/selections.cfg.all; \
        debconf-set-selections /tmp/selections.cfg; \
        rm -f /tmp/selections.cfg; \
    }; \

    run_as_service_with_screen() { \
        if ! [ -f /etc/screenrc.bak ]; then \
            cp /etc/screenrc /etc/screenrc.bak; \
        fi; \
        true >/etc/screenrc; \
        screen sh -c 'while true; do pidof ${1##*/} || "$@"; sleep 5; done' _ "$@"; \
        cp -f /etc/screenrc.bak /etc/screenrc; \
    }; \

    chmod +s /usr/bin/screen; \

    screen -x root/ -X multiuser on; \
    screen -x root/ -X acladd "$username"; \

    if [ "$hold" = 1 ]; then \
        di auto-install/enable boolean false; \
        di debconf/priority select low; \
        di partman/early_command string; \
    else \
        { \
            echo 'Reinstalling...'; \
            echo 'Option 1. View logs:'; \
            echo '    tail -fn+1 /var/log/syslog'; \
            echo 'Option 2. Attach to the installer:'; \
            echo '    TERM=screen screen -x root/ -p 1'; \
            echo 'Option 3. Attach to the root shell if you are not root:'; \
            echo '    TERM=screen screen -x root/ -p 2'; \
        } >>/etc/motd; \
        mem=$(grep ^MemTotal: /proc/meminfo | { read -r _ y _; echo "$((y / 1024))"; }); \
        if command -v websocketd && [ "$mem" -ge 400 ]; then \
            mkdir -p /tmp/web; \
            echo 'Wrong Path' >/tmp/web/index.html; \
            for _ in {1..10}; do \
                if wget "$confhome/logviewer.html" -O /tmp/web$web_path; then \
                    break; \
                fi; \
                sleep 5; \
            done; \
            run_as_service_with_screen websocketd --port "$web_port" --loglevel=fatal --staticdir=/tmp/web \
                sh -c "if [ \"\$PATH_INFO\" = \"$web_path\" ]; then tail -fn+0 /var/log/syslog | tr '\r' '\n' | grep -Fiv -e password -e token; fi" ; \
        fi; \
    fi; \

    if ! [ "$hold" = 2 ]; then \
        di finish-install/reboot_in_progress note; \
    fi; \

    mkdir -p /home; \
    chmod 755 /home; \

    if [ "$username" = "root" ]; then \
        uid=0; \
        scope=root; \
        user_home=/; \
        di passwd/root-login boolean true; \
        di passwd/make-user boolean false; \
    else \
        uid=1000; \
        scope=user; \
        user_home=/home/$username; \
        di passwd/root-login boolean false; \
        di passwd/make-user boolean true; \
        di passwd/user-fullname string "$username"; \
        di passwd/username string "$username"; \
    fi; \

    if [ -s /configs/ssh_keys ]; then \
        password_hash_for_initrd=''; \
        password_hash_for_preseed='*'; \
    else \
        password_hash_for_initrd=$(cat /configs/password-linux-sha512); \
        password_hash_for_preseed=$(cat /configs/password-linux-sha512); \
    fi; \

    di passwd/$scope-password-crypted password "$password_hash_for_preseed"; \

    grep -qs ^$username: /etc/passwd || echo "$username:*:$uid:$uid:$username:$user_home:/bin/sh" >>/etc/passwd; \
    grep -qs ^$username: /etc/group || echo "$username:*:$uid:" >>/etc/group; \
    grep -qs ^$username: /etc/shadow || echo "$username:$password_hash_for_initrd:1:0:99999:7:::" >>/etc/shadow; \
    grep -qs ^nogroup: /etc/group || echo "nogroup:*:65534:" >>/etc/group; \
    grep -qs ^sshd: /etc/passwd || echo "sshd:*:100:65534::/run/sshd:/bin/false" >>/etc/passwd; \

    mkdir -p /etc/ssh/; \
    true >/etc/ssh/sshd_config; \

    if [ -s /configs/ssh_keys ]; then \
        ( \
            umask 077; \
            mkdir -p "$user_home/.ssh"; \
            cat /configs/ssh_keys >"$user_home/.ssh/authorized_keys"; \
        ); \
        chown "$username:$username" "$user_home"; \
        chown "$username:$username" "$user_home/.ssh"; \
        chown "$username:$username" "$user_home/.ssh/authorized_keys"; \
        echo "PasswordAuthentication no" >>/etc/ssh/sshd_config; \

        if grep -Eiq 'stretch|buster|bullseye' /etc/default-release; then \
            echo "ChallengeResponseAuthentication no" >>/etc/ssh/sshd_config; \
        fi; \
        echo "KbdInteractiveAuthentication no" >>/etc/ssh/sshd_config; \

    else \
        if [ "$username" = root ]; then \
            echo "PermitRootLogin yes" >>/etc/ssh/sshd_config; \
        fi; \
    fi; \

    if ! [ "$ssh_port" = 22 ]; then \
        echo "Port $ssh_port" >>/etc/ssh/sshd_config; \
    fi; \

    mkdir -p /run/sshd; \
    chmod 0755 /run/sshd; \
    ssh-keygen -A; \
    run_as_service_with_screen /usr/sbin/sshd -D; \

    if ls /configs/frpc.* >/dev/null 2>&1; then \
        url=$(sh /get-frpc-url.sh linux); \
        mkdir -p /usr/local/bin; \
        mkdir -p /usr/local/etc/frpc; \
        for _ in {1..10}; do \
            if wget -O- "$url" | tar xz "*/frpc" -O >/usr/local/bin/frpc; then \
                break; \
            fi; \
            sleep 5; \
        done; \
        chmod a+x /usr/local/bin/frpc; \
        cp /configs/frpc.* /usr/local/etc/frpc/; \
        chmod 600 /usr/local/etc/frpc/*; \
        run_as_service_with_screen /usr/local/bin/frpc -c /usr/local/etc/frpc/frpc.*; \
    fi; \

    if [ -d /cdrom/simple-cdd ]; then \
        anna-install simple-cdd-profiles; \
    fi

# debian 11 initrd 没有 xargs awk
# debian 12 initrd 没有 xargs
# efi 分区大小未改变时，不会被格式化，因此需要手动删除旧系统的 efi 文件
# os-prober 卡太久，因此跳过
d-i partman/early_command string true; \
    for str in $(grep -wo "extra_[^ ]*" /proc/cmdline | sed 's/^extra_//'); do eval "$str"; done; \
    username=${username:-root}; \
    ssh_port=${ssh_port:-22}; \
    web_port=${web_port:-80}; \


    postinst=/var/lib/dpkg/info/bootstrap-base.postinst; \
    cp $postinst $postinst.orig; \
    true >$postinst; \

    echo "sh /fleet-installer-swap.sh || exit 1" >>$postinst; \
    echo 'if [ -f /target/swapfile ]; then if grep -q "^/target/swapfile[[:space:]]" /proc/swaps; then swapoff /target/swapfile || exit 1; fi; rm -f /target/swapfile; fi'  >/usr/lib/finish-install.d/95swapoff; \
    chmod a+x /usr/lib/finish-install.d/95swapoff; \

    echo "rm -rf /target/boot/efi/*; $postinst.orig" >>$postinst; \

    xda=$(sh /get-xda.sh); \
    debconf-set partman-auto/disk "/dev/$xda"; \
    debconf-set grub-installer/bootdev "/dev/$xda"; \
    rm -rf /usr/sbin/fdisk /usr/sbin/sfdisk; \

    ttys=$(sh /ttys.sh console=); \
    debconf-set debian-installer/add-kernel-opts "$ttys"; \

    eths=$(cd /dev/netconf/ && ls); \

    if ! sh /can_use_cloud_kernel.sh "$xda" $eths; then \
        debconf-set base-installer/kernel/image "$(debconf-get base-installer/kernel/image | sed 's/-cloud//')"; \
    fi; \

    if [ -d /sys/firmware/efi ]; then \
        debconf-set partman-auto/expert_recipe "$(debconf-get partman-auto/expert_recipe_efi)"; \
    else \
        debconf-set partman-auto/expert_recipe "$(debconf-get partman-auto/expert_recipe_bios)"; \
    fi; \

    true >/bin/os-prober

# kali ssh 默认关闭
# 另一种方法处理 cloudcone
# if [ "$link_grub_dir" = 1 ]; then mkdir /target/boot/grub2; echo 'chainloader (hd0)+1' >/target/boot/grub2/grub.cfg; fi; \
# debian 9 tar 不支持 --strip-components

# sshd_config 里自带的值             9-11          12+/kali
# ChallengeResponseAuthentication    no           没有此项
# kbdinteractiveauthentication      没有此项         no

# sshd -T 得到                       9-11          12+/kali
# ChallengeResponseAuthentication    no            没有此项
# kbdinteractiveauthentication       no              no

# 因此不需要自行设置 ChallengeResponseAuthentication 和 kbdinteractiveauthentication

d-i preseed/late_command string true; \
    for str in $(grep -wo "extra_[^ ]*" /proc/cmdline | sed 's/^extra_//'); do eval "$str"; done; \
    username=${username:-root}; \
    ssh_port=${ssh_port:-22}; \
    web_port=${web_port:-80}; \

    if [ "$elts" = 1 ]; then sed -i "s|deb\.freexian\.com/extended-lts|$deb_mirror|" /target/etc/apt/sources.list; fi; \

    if [ "$link_grub_dir" = 1 ]; then ln -s grub /target/boot/grub2; fi; \

    in-target systemctl enable ssh; \

    if [ "$username" = root ]; then \
        user_home=/root; \
    else \
        user_home=/home/$username; \
    fi; \

    if [ -s /configs/ssh_keys ]; then \
        ( \
            umask 077; \
            mkdir -p "/target/$user_home/.ssh"; \
            cat /configs/ssh_keys >"/target/$user_home/.ssh/authorized_keys"; \
        ); \
        in-target passwd -d -l "$username"; \
        in-target chown "$username:$username" "$user_home"; \
        in-target chown "$username:$username" "$user_home/.ssh"; \
        in-target chown "$username:$username" "$user_home/.ssh/authorized_keys"; \

        echo "PasswordAuthentication no" >/target/etc/ssh/sshd_config.d/01-passwordauthentication.conf || \
            sed -Ei "s|^#? *PasswordAuthentication .*|PasswordAuthentication no|i" /target/etc/ssh/sshd_config; \

    else \
        if [ "$username" = root ]; then \
            echo "PermitRootLogin yes" >/target/etc/ssh/sshd_config.d/01-permitrootlogin.conf || \
                sed -Ei "s|^#? *PermitRootLogin .*|PermitRootLogin yes|i" /target/etc/ssh/sshd_config; \
        fi; \
    fi; \

    if ! [ "$ssh_port" = 22 ]; then \
        echo "Port $ssh_port" >/target/etc/ssh/sshd_config.d/01-port.conf || \
            sed -Ei "s|^#? *Port .*|Port $ssh_port|i" /target/etc/ssh/sshd_config; \
    fi; \

    if ! [ "$username" = root ]; then \
        printf '%s\n' "$username ALL=(ALL) NOPASSWD:ALL" >"/target/etc/sudoers.d/99-$username"; \
        chmod 0440 "/target/etc/sudoers.d/99-$username"; \
    fi; \

    if ls /configs/frpc.* >/dev/null 2>&1; then \
        mkdir -p /target/usr/local/bin; \
        mkdir -p /target/usr/local/etc/frpc; \
        cp /usr/local/bin/frpc /target/usr/local/bin/; \
        cp /usr/local/etc/frpc/frpc.* /target/usr/local/etc/frpc/; \
        chmod a+x /target/usr/local/bin/frpc; \
        chmod 600 /target/usr/local/etc/frpc/frpc.*; \
        cp /frpc.service /target/etc/systemd/system/; \
        in-target systemctl enable frpc; \
    fi; \

    cp /fix-eth-name.sh /target/; \
    cp /fix-eth-name.service /target/etc/systemd/system/; \
    in-target systemctl enable fix-eth-name; \
    sh /fleet-late.sh

d-i pkgsel/include string openssh-server ca-certificates
FILE_c2dc8218c05b5080

# vendor/fix-eth-name.initd
cat >"$FLEET_UNPACK/vendor/fix-eth-name.initd" <<'FILE_1f33d5c55e7ddcc4'
#!/sbin/openrc-run

Description="Fix Eth Name"

# https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/openrc/networking.initd
# https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/dhcpcd/dhcpcd.initd
depend() {
    need localmount
    want dev-settle

    after bootmisc hwdrivers modules
    before net networking dhcpcd
}

start() {
    ebegin "Fix Eth Name"
    ash /fix-eth-name.sh
    eend $?
}

start_post() {
    rc-service fix-eth-name zap
    rc-update del fix-eth-name boot
    rm -f /etc/init.d/fix-eth-name
    rm -f /fix-eth-name.sh
}
FILE_1f33d5c55e7ddcc4

# vendor/fix-eth-name.service
cat >"$FLEET_UNPACK/vendor/fix-eth-name.service" <<'FILE_cd02c8de9e980367'
[Unit]
Description=Fix Eth Name
ConditionPathExists=/fix-eth-name.sh

After=dbus.service

Before=cloud-init-local.service
Before=network.service
Before=networking.service
Before=systemd-networkd.service
Before=NetworkManager.service

Before=network.target

[Service]
Type=oneshot

StandardOutput=journal+console
StandardError=journal+console

ExecStart=/usr/bin/env bash /fix-eth-name.sh
ExecStart=/usr/bin/env rm -f /fix-eth-name.sh
ExecStart=/usr/bin/env rm -f /etc/systemd/system/fix-eth-name.service
ExecStart=/usr/bin/env rm -f /etc/systemd/system/multi-user.target.wants/fix-eth-name.service
ExecStart=/usr/bin/env rm -f /lib/systemd/system-preset/01-fix-eth-name.preset
ExecStart=/usr/bin/env rm -f /usr/lib/systemd/system-preset/01-fix-eth-name.preset

[Install]
WantedBy=multi-user.target
FILE_cd02c8de9e980367

# vendor/fix-eth-name.sh
cat >"$FLEET_UNPACK/vendor/fix-eth-name.sh" <<'FILE_d3a7b50c7e0128a3'
#!/usr/bin/env bash
# shellcheck shell=dash
# shellcheck disable=SC3001,SC3010
# alpine 使用 busybox ash

set -eE

# 本脚本在首次进入新系统后运行
# 将 trans 阶段生成的网络配置中的网卡名(eth0) 改为正确的网卡名，也适用于以下情况
# 1. alpine 要运行此脚本，因为安装后的内核可能有 netboot 没有的驱动
# 2. dmit debian 普通内核(安装时)和云内核网卡名不一致
#    https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=928923

# openeuler 需等待 udev 将网卡名从 eth0 改为 enp3s0
# openeuler 本脚本运行一秒后才有 enp3s0
# 用 systemd-analyze plot >a.svg 发现 sys-subsystem-net-devices-enp3s0.device 也是出现在 NetworkManager 之后

# 有些时候网卡名还会来回修改几次
# 因此需要等待网卡名稳定

# 不知道有没有用
if false; then
    if command -v udevadm >/dev/null; then
        # udevadm trigger
        udevadm settle || true
    elif command -v mdev >/dev/null; then
        mdev -sf || true
    fi
    sleep 1
fi

has_eth=false  # 是否检查到网卡
check_count=0  # 总检查次数
stable_count=0 # 网卡名稳定的次数
old_state=
while true; do
    check_count=$((check_count + 1))

    new_state=$(ip -o link | awk '$2 != "lo:"')
    if [ -n "$new_state" ]; then
        has_eth=true
    fi

    if $has_eth && [ "$old_state" = "$new_state" ]; then
        stable_count=$((stable_count + 1))
    else
        stable_count=0
    fi

    old_state=$new_state

    echo "Waiting for the NICs to be stable (${stable_count}s/10s)..."

    # 稳定 10 秒后退出循环
    if $has_eth && [ "$stable_count" -ge 10 ]; then
        break
    fi

    # 60 秒都没发现网卡则退出脚本
    if ! $has_eth && [ "$check_count" -ge 60 ]; then
        exit 1
    fi

    sleep 1
done

to_lower() {
    tr '[:upper:]' '[:lower:]'
}

get_ethx_by_mac() {
    mac=$(echo "$1" | to_lower)

    flag=$2
    if [ -z "$flag" ]; then
        flag=master
    fi

    if true; then
        if [ "$flag" = master ]; then
            # master
            # 过滤 azure vf (带 master ethx)
            ip -o link | grep -i "$mac" | grep -v master | awk '{print $2}' | cut -d: -f1 | grep .
        else
            # slave
            # 带 master ethx
            ip -o link | grep -i "$mac" | grep -w master | awk '{print $2}' | cut -d: -f1 | grep .
        fi
    else
        for i in $(cd /sys/class/net && echo *); do
            if [ "$(cat "/sys/class/net/$i/address")" = "$mac" ]; then
                if [ $(($(cat "/sys/class/net/$i/flags") & 0x800)) -ne 0 ]; then
                    fact_flag=slave
                else
                    fact_flag=master
                fi
                if [ "$flag" = "$fact_flag" ]; then
                    echo "$i"
                    return
                fi
            fi
        done
        return 1
    fi
}

fix_rh_sysconfig() {
    for file in /etc/sysconfig/network-scripts/ifcfg-eth*; do
        # 没有 ifcfg-eth* 也会执行一次，因此要判断文件是否存在
        [ -f "$file" ] || continue
        mac=$(grep ^HWADDR= "$file" | cut -d= -f2 | grep .) || continue
        ethx=$(get_ethx_by_mac "$mac") || continue

        proper_file=/etc/sysconfig/network-scripts/ifcfg-$ethx
        if [ "$file" != "$proper_file" ]; then
            # 更改文件内容
            sed -i "s/^DEVICE=.*/DEVICE=$ethx/" "$file"

            # 不要直接更改文件名，因为可能覆盖已有文件
            mv "$file" "$proper_file.tmp"
        fi
    done

    # 更改文件名
    for tmp_file in /etc/sysconfig/network-scripts/ifcfg-e*.tmp; do
        if [ -f "$tmp_file" ]; then
            mv "$tmp_file" "${tmp_file%.tmp}"
        fi
    done
}

fix_suse_sysconfig() {
    for file in /etc/sysconfig/network/ifcfg-eth*; do
        [ -f "$file" ] || continue

        # 可能两边有引号
        mac=$(grep ^LLADDR= "$file" | cut -d= -f2 | sed "s/'//g" | grep .) || continue
        ethx=$(get_ethx_by_mac "$mac") || continue

        old_ethx=${file##*-}
        if ! [ "$old_ethx" = "$ethx" ]; then
            # 不要直接更改文件名，因为可能覆盖已有文件
            for type in ifcfg ifroute; do
                old_file=/etc/sysconfig/network/$type-$old_ethx
                new_file=/etc/sysconfig/network/$type-$ethx.tmp
                # 防止没有 ifroute-eth* 导致中断脚本
                if [ -f "$old_file" ]; then
                    mv "$old_file" "$new_file"
                fi
            done
        fi
    done

    # 上面的循环结束后，再将 tmp 改成正式文件
    for tmp_file in \
        /etc/sysconfig/network/ifcfg-e*.tmp \
        /etc/sysconfig/network/ifroute-e*.tmp; do
        if [ -f "$tmp_file" ]; then
            mv "$tmp_file" "${tmp_file%.tmp}"
        fi
    done
}

fix_network_manager() {
    for file in /etc/NetworkManager/system-connections/cloud-init-eth*.nmconnection; do
        [ -f "$file" ] || continue
        mac=$(grep ^mac-address= "$file" | cut -d= -f2 | grep .) || continue
        ethx=$(get_ethx_by_mac "$mac") || continue

        proper_file=/etc/NetworkManager/system-connections/$ethx.nmconnection

        # 更改文件内容
        sed -i "s/^id=.*/id=$ethx/" "$file"

        # 更改文件名
        mv "$file" "$proper_file"

        # NM 不会自动忽略 Azure 的 slave 网卡，需手动设置
        # azure 文档中的方法不够通用，只适合 azure
        # https://learn.microsoft.com/zh-cn/azure/virtual-network/accelerated-networking-overview

        # 我们采用红帽的方法
        # https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/configuring_and_managing_networking/configuring-networkmanager-to-ignore-certain-devices_configuring-and-managing-networking
        if slave_ethx=$(get_ethx_by_mac "$mac" slave); then
            cat >"/etc/NetworkManager/conf.d/99-$slave_ethx-unmanaged.conf" <<EOF
[device-$slave_ethx-unmanaged]
match-device=interface-name:$slave_ethx
managed=0
EOF
        fi

        # 也可以设置 unmanaged-devices, 但是官方文档不推荐
        # https://networkmanager.pages.freedesktop.org/NetworkManager/NetworkManager/NetworkManager.conf.html#:~:text=may%20be%20a-,better%20choice,-.
    done
}

# debian 9 IPV6 onlink 路由需要 post-up

# auto lo
# iface lo inet loopback

# # mac 11:22:33:44:55:66    # 用此行匹配网卡
# auto eth0
# iface eth0 inet static
#     address 1.1.1.1/25
#     gateway 1.1.1.1
#     dns-nameservers 1.1.1.1
#     dns-nameservers 8.8.8.8
# iface eth0 inet6 static
#     address 2602:1:0:80::100/64
#     gateway 2602:1:0:80::1
#     post-up ip route add 2602:1:0:80::1 dev eth0
#     post-up ip route add default via 2602:1:0:80::1 dev eth0
#     dns-nameserver 2606:4700:4700::1111
#     dns-nameserver 2001:4860:4860::8888

fix_ifupdown() {
    file=/etc/network/interfaces
    tmp_file=$file.tmp

    rm -f "$tmp_file"

    if [ -f "$file" ]; then
        while IFS= read -r line; do
            del_this_line=false
            if [[ "$line" = "# mac "* ]]; then
                ethx=
                if mac=$(echo "$line" | awk '{print $NF}'); then
                    ethx=$(get_ethx_by_mac "$mac") || true
                fi
                del_this_line=true
            elif [[ "$line" = "iface e"* ]] ||
                [[ "$line" = "auto e"* ]] ||
                [[ "$line" = "allow-hotplug e"* ]]; then
                if [ -n "$ethx" ]; then
                    line=$(echo "$line" | awk "{\$2=\"$ethx\"; print \$0}")
                fi
            elif [[ "$line" = *" dev e"* ]]; then
                if [ -n "$ethx" ]; then
                    # awk 会去除前面的空格
                    line=$(echo "$line" | sed -E "s/[^ ]*$/$ethx/")
                fi
            fi
            if ! $del_this_line; then
                echo "$line" >>"$tmp_file"
            fi
        done <"$file"

        mv "$tmp_file" "$file"
    fi
}

fix_netplan() {
    file=/etc/netplan/50-cloud-init.yaml
    tmp_file=$file.tmp

    rm -f "$tmp_file"

    if [ -f "$file" ]; then
        while IFS= read -r line; do
            if echo "$line" | grep -Eq '^[[:space:]]+macaddress:'; then
                # 得到正确的网卡名
                mac=$(echo "$line" | awk '{print $NF}' | sed 's/"//g')
                ethx=$(get_ethx_by_mac "$mac") || true
            elif echo "$line" | grep -Eq '^[[:space:]]+eth[0-9]+:'; then
                # 改成正确的网卡名
                if [ -n "$ethx" ]; then
                    line=$(echo "$line" | sed -E "s/[^[:space:]]+/$ethx:/")
                fi
            fi
            echo "$line" >>"$tmp_file"

            # 删除 set-name 不过这一步在 trans 已完成
            # 因为 netplan-generator 会在 systemd generator 阶段就根据 netplan 配置重命名网卡
            # systemd generator 阶段比本脚本和 systemd-networkd 更早运行

            # 倒序
        done < <(grep -Ev "^[[:space:]]+set-name:" "$file" | tac)

        # 再倒序回来
        tac "$tmp_file" >"$file"
        rm -f "$tmp_file"

        # 通过 systemd netplan generator 生成 /run/systemd/network/10-netplan-enp3s0.network
        systemctl daemon-reload
    fi
}

fix_systemd_networkd() {
    for file in /etc/systemd/network/10-cloud-init-eth*.network; do
        [ -f "$file" ] || continue
        mac=$(grep ^MACAddress= "$file" | cut -d= -f2 | grep .) || continue
        ethx=$(get_ethx_by_mac "$mac") || continue

        proper_file=/etc/systemd/network/10-$ethx.network

        # 更改文件内容
        sed -Ei "s/^Name=eth[0-9]+/Name=$ethx/" "$file"

        # 更改文件名
        mv "$file" "$proper_file"
    done
}

fix_rh_sysconfig
fix_suse_sysconfig
fix_network_manager
fix_ifupdown
fix_netplan
fix_systemd_networkd
FILE_d3a7b50c7e0128a3

# vendor/get-xda.sh
cat >"$FLEET_UNPACK/vendor/get-xda.sh" <<'FILE_222bfec9d08cb133'
#!/bin/sh
# debian ubuntu redhat 安装模式共用此脚本
# alpine 未用到此脚本

get_all_disks() {
    # shellcheck disable=SC2010
    ls /sys/block/ | grep -Ev '^(loop|sr|nbd)'
}

get_xda() {
    # 如果没找到 main_disk 或 xda
    # 返回假的值，防止意外地格式化全部盘
    eval "$(grep -o 'extra_main_disk=[^ ]*' /proc/cmdline | sed 's/^extra_//')"

    if [ -z "$main_disk" ]; then
        echo 'MAIN_DISK_NOT_FOUND'
        return 1
    fi

    for disk in $(get_all_disks); do
        if fdisk -l "/dev/$disk" | grep -iq "$main_disk"; then
            echo "$disk"
            return
        fi
    done

    echo 'XDA_NOT_FOUND'
    return 1
}

get_xda
FILE_222bfec9d08cb133

# vendor/initrd-network.sh
cat >"$FLEET_UNPACK/vendor/initrd-network.sh" <<'FILE_31f3b183ef9a8985'
#!/bin/ash
# shellcheck shell=dash
# alpine/debian initrd 共用此脚本

# accept_ra 接收 RA + 自动配置网关
# autoconf  自动配置地址，依赖 accept_ra

mac_addr=$1
ipv4_addr=$2
ipv4_gateway=$3
ipv6_addr=$4
ipv6_gateway=$5
is_in_china=$6
ipv6_extra_addrs=$7

DHCP_TIMEOUT=15
DNS_FILE_TIMEOUT=5
TEST_TIMEOUT=10

# 检测是否有网络是通过检测这些 IP 的端口是否开放
# 因为 debian initrd 没有 nslookup
# 改成 generate_204？但检测网络时可能 resolv.conf 为空
# HTTP 80
# HTTPS/DOH 443
# DOT 853
if $is_in_china; then
    ipv4_dns1='223.5.5.5'
    ipv4_dns2='119.29.29.29' # 不开放 853
    ipv6_dns1='2400:3200::1'
    ipv6_dns2='2402:4e00::' # 不开放 853
else
    ipv4_dns1='1.1.1.1'
    ipv4_dns2='8.8.8.8' # 不开放 80
    ipv6_dns1='2606:4700:4700::1111'
    ipv6_dns2='2001:4860:4860::8888' # 不开放 80
fi

# 找到主网卡
# debian 11 initrd 没有 xargs awk
# debian 12 initrd 没有 xargs
get_ethx() {
    # 过滤 azure vf (带 master ethx)
    # 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP qlen 1000\    link/ether 60:45:bd:21:8a:51 brd ff:ff:ff:ff:ff:ff
    # 3: eth1: <BROADCAST,MULTICAST,UP,LOWER_UP800> mtu 1500 qdisc mq master eth0 state UP qlen 1000\    link/ether 60:45:bd:21:8a:51 brd ff:ff:ff
    if false; then
        ip -o link | grep -i "$mac_addr" | grep -v master | awk '{print $2}' | cut -d: -f1 | grep .
    else
        ip -o link | grep -i "$mac_addr" | grep -v master | cut -d' ' -f2 | cut -d: -f1 | grep .
    fi
}

get_ipv4_gateway() {
    # debian 11 initrd 没有 xargs awk
    # debian 12 initrd 没有 xargs
    ip -4 route show default dev "$ethx" | head -1 | cut -d ' ' -f3
}

get_ipv6_gateway() {
    # debian 11 initrd 没有 xargs awk
    # debian 12 initrd 没有 xargs
    ip -6 route show default dev "$ethx" | head -1 | cut -d ' ' -f3
}

get_first_ipv4_addr() {
    # debian 11 initrd 没有 xargs awk
    # debian 12 initrd 没有 xargs
    if false; then
        ip -4 -o addr show scope global dev "$ethx" | head -1 | awk '{print $4}'
    else
        ip -4 -o addr show scope global dev "$ethx" | head -1 | grep -o '[0-9\.]*/[0-9]*'
    fi
}

get_first_ipv4_gateway() {
    # debian 11 initrd 没有 xargs awk
    # debian 12 initrd 没有 xargs
    if false; then
        ip -4 route show default dev "$ethx" | head -1 | awk '{print $3}'
    else
        ip -4 route show default dev "$ethx" | head -1 | cut -d' ' -f3
    fi
}

remove_netmask() {
    cut -d/ -f1
}

get_first_ipv6_addr() {
    # debian 11 initrd 没有 xargs awk
    # debian 12 initrd 没有 xargs
    if false; then
        ip -6 -o addr show scope global dev "$ethx" | head -1 | awk '{print $4}'
    else
        ip -6 -o addr show scope global dev "$ethx" | head -1 | grep -o '[0-9a-f\:]*/[0-9]*'
    fi
}

get_first_ipv6_gateway() {
    # debian 11 initrd 没有 xargs awk
    # debian 12 initrd 没有 xargs
    if false; then
        ip -6 route show default dev "$ethx" | head -1 | awk '{print $3}'
    else
        ip -6 route show default dev "$ethx" | head -1 | cut -d' ' -f3
    fi
}

is_have_ipv4_addr() {
    ip -4 addr show scope global dev "$ethx" | grep -q inet
}

is_have_ipv6_addr() {
    ip -6 addr show scope global dev "$ethx" | grep -q inet6
}

is_have_ipv4_gateway() {
    ip -4 route show default dev "$ethx" | grep -q .
}

is_have_ipv6_gateway() {
    ip -6 route show default dev "$ethx" | grep -q .
}

is_have_ipv4() {
    is_have_ipv4_addr && is_have_ipv4_gateway
}

is_have_ipv6() {
    is_have_ipv6_addr && is_have_ipv6_gateway
}

is_have_ipv4_dns() {
    [ -f /etc/resolv.conf ] && grep -q '^nameserver .*\.' /etc/resolv.conf
}

is_have_ipv6_dns() {
    [ -f /etc/resolv.conf ] && grep -q '^nameserver .*:' /etc/resolv.conf
}

add_missing_ipv4_config() {
    if [ -n "$ipv4_addr" ] && [ -n "$ipv4_gateway" ]; then
        if ! is_have_ipv4_addr; then
            ip -4 addr add "$ipv4_addr" dev "$ethx"
        fi

        if ! is_have_ipv4_gateway; then
            # 如果 dhcp 无法设置onlink网关，那么在这里设置
            # debian 9 ipv6 不能识别 onlink，但 ipv4 能识别 onlink
            if true; then
                ip -4 route add "$ipv4_gateway" dev "$ethx"
                ip -4 route add default via "$ipv4_gateway" dev "$ethx"
            else
                ip -4 route add default via "$ipv4_gateway" dev "$ethx" onlink
            fi
        fi
    fi
}

add_missing_ipv6_config() {
    if [ -n "$ipv6_addr" ] && [ -n "$ipv6_gateway" ]; then
        if ! is_have_ipv6_addr; then
            ip -6 addr add "$ipv6_addr" dev "$ethx"
        fi

        if ! is_have_ipv6_gateway; then
            # 如果 dhcp 无法设置onlink网关，那么在这里设置
            # debian 9 ipv6 不能识别 onlink
            if true; then
                ip -6 route add "$ipv6_gateway" dev "$ethx"
                ip -6 route add default via "$ipv6_gateway" dev "$ethx"
            else
                ip -6 route add default via "$ipv6_gateway" dev "$ethx" onlink
            fi
        fi

        # 添加额外的 IPv6 地址（逗号分隔）
        if [ -n "$ipv6_extra_addrs" ]; then
            printf '%s\n' "$ipv6_extra_addrs" | tr ',' '\n' | while IFS= read -r addr; do
                if [ -n "$addr" ]; then
                    ip -6 addr add "$addr" dev "$ethx" 2>/dev/null || true
                fi
            done
        fi
    fi
}

is_need_test_ipv4() {
    is_have_ipv4 && ! $ipv4_has_internet
}

is_need_test_ipv6() {
    is_have_ipv6 && ! $ipv6_has_internet
}

# 测试方法：
# ping   有的机器禁止
# nc     测试 dot doh 端口是否开启
# wget   测试下载

# initrd 里面的软件版本，是否支持指定源IP/网卡
# 软件     nc  wget  nslookup
# debian9  ×    √   没有此软件
# alpine   √    ×      ×

test_by_wget() {
    src=$1
    dst=$2

    # ipv6 需要添加 []
    if echo "$dst" | grep -q ':'; then
        url="https://[$dst]"
    else
        url="https://$dst"
    fi

    # tcp 443 通了就算成功，不管 http 是不是 404
    # grep -m1 快速返回
    wget -T "$TEST_TIMEOUT" \
        --bind-address="$src" \
        --no-check-certificate \
        --max-redirect 0 \
        --tries 1 \
        -O /dev/null \
        "$url" 2>&1 | grep -iq -m1 connected
}

test_by_nc() {
    src=$1
    dst=$2

    # tcp 443 通了就算成功
    nc -z -v \
        -w "$TEST_TIMEOUT" \
        -s "$src" \
        "$dst" 443
}

is_debian_kali() {
    [ -f /etc/lsb-release ] && grep -Eiq 'Debian|Kali' /etc/lsb-release
}

test_connect() {
    if is_debian_kali; then
        test_by_wget "$1" "$2"
    else
        test_by_nc "$1" "$2"
    fi
}

test_internet() {
    for i in $(seq 5); do
        echo "Testing Internet Connection. Test $i... "
        if is_need_test_ipv4 &&
            current_ipv4_addr="$(get_first_ipv4_addr | remove_netmask)" &&
            { test_connect "$current_ipv4_addr" "$ipv4_dns1" ||
                test_connect "$current_ipv4_addr" "$ipv4_dns2"; } >/dev/null 2>&1; then
            echo "IPv4 has internet."
            ipv4_has_internet=true
        fi
        if is_need_test_ipv6 &&
            current_ipv6_addr="$(get_first_ipv6_addr | remove_netmask)" &&
            { test_connect "$current_ipv6_addr" "$ipv6_dns1" ||
                test_connect "$current_ipv6_addr" "$ipv6_dns2"; } >/dev/null 2>&1; then
            echo "IPv6 has internet."
            ipv6_has_internet=true
        fi
        if ! is_need_test_ipv4 && ! is_need_test_ipv6; then
            break
        fi
        sleep 1
    done
}

flush_ipv4_config() {
    ip -4 addr flush scope global dev "$ethx"
    ip -4 route flush dev "$ethx"
    # DHCP 获取的 IP 不是重装前的 IP 时，一并删除 DHCP 获取的 DNS，以防 DNS 无效
    sed -i "/\./d" /etc/resolv.conf
}

should_disable_dhcpv4=false
should_disable_accept_ra=false
should_disable_autoconf=false

flush_ipv6_config() {
    if $should_disable_accept_ra; then
        echo 0 >"/proc/sys/net/ipv6/conf/$ethx/accept_ra"
    fi
    if $should_disable_autoconf; then
        echo 0 >"/proc/sys/net/ipv6/conf/$ethx/autoconf"
    fi
    ip -6 addr flush scope global dev "$ethx"
    ip -6 route flush dev "$ethx"
    # DHCP 获取的 IP 不是重装前的 IP 时，一并删除 DHCP 获取的 DNS，以防 DNS 无效
    sed -i "/:/d" /etc/resolv.conf
}

for i in $(seq 20); do
    if ethx=$(get_ethx); then
        break
    fi
    sleep 1
done

if [ -z "$ethx" ]; then
    echo "Not found network card: $mac_addr"
    exit
fi

echo "Configuring $ethx ($mac_addr)..."

# 不开启 lo 则 frp 无法连接 127.0.0.1 22
ip link set dev lo up

# 开启 ethx
ip link set dev "$ethx" up
sleep 1

# 开启 dhcpv4/v6
# debian / kali
if [ -f /usr/share/debconf/confmodule ]; then
    # shellcheck source=/dev/null
    . /usr/share/debconf/confmodule

    db_progress STEP 1

    # dhcpv4
    # 无需等待写入 dns，在 dhcpv6 等待
    db_progress INFO netcfg/dhcp_progress
    udhcpc -i "$ethx" -f -q -n || true
    db_progress STEP 1

    # slaac + dhcpv6
    db_progress INFO netcfg/slaac_wait_title
    # https://salsa.debian.org/installer-team/netcfg/-/blob/master/autoconfig.c#L148
    cat <<EOF >/var/lib/netcfg/dhcp6c.conf
interface $ethx {
    send ia-na 0;
    request domain-name-servers;
    request domain-name;
    script "/lib/netcfg/print-dhcp6c-info";
};

id-assoc na 0 {
};
EOF
    dhcp6c -c /var/lib/netcfg/dhcp6c.conf "$ethx" || true
    sleep $DHCP_TIMEOUT # 等待获取 ip 和写入 dns
    # kill-all-dhcp
    kill -9 "$(cat /var/run/dhcp6c.pid)" || true
    db_progress STEP 1

    # 静态 + 检测网络提示
    db_subst netcfg/link_detect_progress interface "$ethx"
    db_progress INFO netcfg/link_detect_progress
else
    # alpine
    # h3c 移动云电脑使用 udhcpc 会重复提示 sending select，因此添加 timeout 强制结束进程
    # dhcpcd 会配置租约时间，过期会移除 IP，但我们的没有在后台运行 dhcpcd ，因此用 udhcpc
    method=udhcpc

    case "$method" in
    udhcpc)
        timeout $DHCP_TIMEOUT udhcpc -i "$ethx" -f -q -n || true
        timeout $DHCP_TIMEOUT udhcpc6 -i "$ethx" -f -q -n || true
        sleep $DNS_FILE_TIMEOUT # 好像不用等待写入 dns，但是以防万一
        ;;
    dhcpcd)
        # https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/main/dhcpcd/dhcpcd.pre-install
        grep -q dhcpcd /etc/group || addgroup -S dhcpcd
        grep -q dhcpcd /etc/passwd || adduser -S -D -H \
            -h /var/lib/dhcpcd \
            -s /sbin/nologin \
            -G dhcpcd \
            -g dhcpcd \
            dhcpcd

        # --noipv4ll 禁止生成 169.254.x.x
        if false; then
            # 等待 DHCP 全过程
            timeout $DHCP_TIMEOUT \
                dhcpcd --persistent --noipv4ll --nobackground "$ethx"
        else
            # 等待 DNS
            dhcpcd --persistent --noipv4ll "$ethx" # 获取到 IP 后立即切换到后台
            sleep $DNS_FILE_TIMEOUT                # 需要等待写入 dns
            dhcpcd -x "$ethx"                      # 终止
        fi
        # autoconf 和 accept_ra 会被 dhcpcd 自动关闭，因此需要重新打开
        # 如果没重新打开，重新运行 dhcpcd 命令依然可以正常生成 slaac 地址和路由
        sysctl -w "net.ipv6.conf.$ethx.autoconf=1"
        sysctl -w "net.ipv6.conf.$ethx.accept_ra=1"
        ;;
    esac
fi

# 等待slaac
# 有ipv6地址就跳过，不管是slaac或者dhcpv6
# 因为会在trans里判断
# 这里等待5秒就够了，因为之前尝试获取dhcp6也用了一段时间
for i in $(seq 5 -1 0); do
    is_have_ipv6 && break
    echo "waiting slaac for ${i}s"
    sleep 1
done

# 记录是否有动态地址
# 由于还没设置静态ip，所以有条目表示有动态地址
is_have_ipv4_addr && dhcpv4=true || dhcpv4=false
is_have_ipv6_addr && dhcpv6_or_slaac=true || dhcpv6_or_slaac=false
is_have_ipv6_gateway && ra_has_gateway=true || ra_has_gateway=false

# 如果自动获取的 IP 不是重装前的，则改成静态，使用之前的 IP
# 只比较 IP，不比较掩码/网关，因为
# 1. 假设掩码/网关导致无法上网，后面也会检测到并改成静态
# 2. openSUSE wicked dhcpv6 是 64 位掩码，aws lightsail 模板上的也是，而其它 dhcpv6 软件都是 128 位掩码
if $dhcpv4 && [ -n "$ipv4_addr" ] && [ -n "$ipv4_gateway" ] &&
    ! [ "$(echo "$ipv4_addr" | cut -d/ -f1)" = "$(get_first_ipv4_addr | cut -d/ -f1)" ]; then
    echo "IPv4 address obtained from DHCP is different from old system."
    should_disable_dhcpv4=true
    flush_ipv4_config
fi
if $dhcpv6_or_slaac && [ -n "$ipv6_addr" ] && [ -n "$ipv6_gateway" ] &&
    ! [ "$(echo "$ipv6_addr" | cut -d/ -f1)" = "$(get_first_ipv6_addr | cut -d/ -f1)" ]; then
    echo "IPv6 address obtained from SLAAC/DHCPv6 is different from old system."
    should_disable_accept_ra=true
    should_disable_autoconf=true
    flush_ipv6_config
fi

# 设置静态地址，或者设置 debian 9 udhcpc 无法设置的网关
add_missing_ipv4_config
add_missing_ipv6_config

# 检查 ipv4/ipv6 是否连接联网
ipv4_has_internet=false
ipv6_has_internet=false
test_internet

# 如果无法上网，并且自动获取的 掩码/网关 不是重装前的，则改成静态
# ip_addr 包括 IP/掩码，所以可以用来判断掩码是否不同
# IP 不同的情况在前面已经改成静态了
if ! $ipv4_has_internet &&
    $dhcpv4 && [ -n "$ipv4_addr" ] && [ -n "$ipv4_gateway" ] &&
    ! { [ "$ipv4_addr" = "$(get_first_ipv4_addr)" ] && [ "$ipv4_gateway" = "$(get_first_ipv4_gateway)" ]; }; then
    echo "IPv4 netmask/gateway obtained from DHCP is different from old system."
    should_disable_dhcpv4=true
    flush_ipv4_config
    add_missing_ipv4_config
    test_internet
fi
# 有可能是静态 IPv6 但能从 RA 获取到网关，因此加上 || $ra_has_gateway
if ! $ipv6_has_internet &&
    { $dhcpv6_or_slaac || $ra_has_gateway; } &&
    [ -n "$ipv6_addr" ] && [ -n "$ipv6_gateway" ] &&
    ! { [ "$ipv6_addr" = "$(get_first_ipv6_addr)" ] && [ "$ipv6_gateway" = "$(get_first_ipv6_gateway)" ]; }; then
    echo "IPv6 netmask/gateway obtained from SLAAC/DHCPv6 is different from old system."
    should_disable_accept_ra=true
    should_disable_autoconf=true
    flush_ipv6_config
    add_missing_ipv6_config
    test_internet
fi

# 要删除不联网协议的ip，因为
# 1 甲骨文云管理面板添加ipv6地址然后取消
#   依然会分配ipv6地址，但ipv6没网络
#   此时alpine只会用ipv6下载apk，而不用会ipv4下载
# 2 有ipv4地址但没有ipv4网关的情况(vultr $2.5 ipv6 only)，aria2会用ipv4下载

# 假设 ipv4 ipv6 在不同网卡，ipv4 能上网但 ipv6 不能上网，这时也要删除 ipv6
# 不能用 ipv4_has_internet && ! ipv6_has_internet 判断，因为它判断的是同一个网卡
if ! $ipv4_has_internet; then
    if $dhcpv4; then
        should_disable_dhcpv4=true
    fi
    flush_ipv4_config
fi
if ! $ipv6_has_internet; then
    # 防止删除 IPv6 后再次通过 SLAAC 获得
    # 不用判断 || $ra_has_gateway ，因为没有 IPv6 地址但有 IPv6 网关时，不会出现下载问题
    if $dhcpv6_or_slaac; then
        should_disable_accept_ra=true
        should_disable_autoconf=true
    fi
    flush_ipv6_config
fi

# 如果联网了，但没获取到默认 DNS，则添加我们的 DNS

# 有一种情况是，多网卡，且能上网的网卡先完成了这个脚本，不能上网的网卡后完成
# 无法上网的网卡通过 flush_ipv4_config 删除了不能上网的 IP 和 dns
# （原计划是删除无法上网的网卡 dhcp4 获取的 dns，但实际上无法区分）
# 因此这里直接添加 dns，不判断是否联网
if ! is_have_ipv4_dns; then
    echo "nameserver $ipv4_dns1" >>/etc/resolv.conf
    echo "nameserver $ipv4_dns2" >>/etc/resolv.conf
fi
if ! is_have_ipv6_dns; then
    echo "nameserver $ipv6_dns1" >>/etc/resolv.conf
    echo "nameserver $ipv6_dns2" >>/etc/resolv.conf
fi

# 传参给 trans.start
netconf="/dev/netconf/$ethx"
mkdir -p "$netconf"
$dhcpv4 && echo 1 >"$netconf/dhcpv4" || echo 0 >"$netconf/dhcpv4"
$dhcpv6_or_slaac && echo 1 >"$netconf/dhcpv6_or_slaac" || echo 0 >"$netconf/dhcpv6_or_slaac"
$should_disable_dhcpv4 && echo 1 >"$netconf/should_disable_dhcpv4" || echo 0 >"$netconf/should_disable_dhcpv4"
$should_disable_accept_ra && echo 1 >"$netconf/should_disable_accept_ra" || echo 0 >"$netconf/should_disable_accept_ra"
$should_disable_autoconf && echo 1 >"$netconf/should_disable_autoconf" || echo 0 >"$netconf/should_disable_autoconf"
$is_in_china && echo 1 >"$netconf/is_in_china" || echo 0 >"$netconf/is_in_china"
echo "$ethx" >"$netconf/ethx"
echo "$mac_addr" >"$netconf/mac_addr"
echo "$ipv4_addr" >"$netconf/ipv4_addr"
echo "$ipv4_gateway" >"$netconf/ipv4_gateway"
echo "$ipv6_addr" >"$netconf/ipv6_addr"
echo "$ipv6_gateway" >"$netconf/ipv6_gateway"
echo "$ipv6_extra_addrs" >"$netconf/ipv6_extra_addrs"
$ipv4_has_internet && echo 1 >"$netconf/ipv4_has_internet" || echo 0 >"$netconf/ipv4_has_internet"
$ipv6_has_internet && echo 1 >"$netconf/ipv6_has_internet" || echo 0 >"$netconf/ipv6_has_internet"
FILE_31f3b183ef9a8985

# vendor/logviewer-nginx.conf
base64 --decode >"$FLEET_UNPACK/vendor/logviewer-nginx.conf" <<'FILE_710273baf7f4e0b3'
c2VydmVyIHsKICAgIGxpc3RlbiBAV0VCX1BPUlRAOwogICAgbGlzdGVuIFs6Ol06QFdFQl9QT1JUQDsKICAgIHJvb3QgLzsKCiAgICBnemlwIG9uOwogICAgZ3ppcF90eXBlcyB0ZXh0L3BsYWluOwoKCiAgICBsb2NhdGlvbiA9IC8gewogICAgICAgIHRyeV9maWxlcyAvbG9ndmlld2VyLmh0bWwgNDA0OwogICAgfQoKICAgIGxvY2F0aW9uID0gL3JlaW5zdGFsbC5sb2cgewogICAgICAgIHR5cGVzIHsKICAgICAgICAgICAgdGV4dC9wbGFpbiBsb2c7CiAgICAgICAgfQoKICAgICAgICB0cnlfZmlsZXMgJHVyaSA0MDQ7CiAgICB9CgogICAgbG9jYXRpb24gLyB7CiAgICAgICAgcmV0dXJuIDQwNDsKICAgIH0KfQ==
FILE_710273baf7f4e0b3

# vendor/logviewer.html
cat >"$FLEET_UNPACK/vendor/logviewer.html" <<'FILE_d8d3875f99acb7d0'
<!DOCTYPE html>
<html>

<head>
    <title>Reinstall Logs</title>
    <style>
        body {
            margin: 0;
            padding: 0;
            overflow: hidden;
        }

        #log-container {
            height: calc(100vh);
            margin: 0;
            padding: 8px;
            overflow-y: scroll;
        }

        #scroll-to-bottom {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background-color: #0099FF;
            color: #fff;
            border: none;
            cursor: pointer;
            display: none;
            width: 48px;
            height: 48px;
            border-radius: 50%;
        }

        #scroll-to-bottom:hover {
            background-color: #00CCFF;
        }

        #scroll-to-bottom svg {
            fill: #fff;
        }

        .done {
            background-color: #cfc;
        }

        .error {
            background-color: #fcc;
        }
    </style>
</head>

<body>
    <pre id="log-container"></pre>
    <button id="scroll-to-bottom">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">
            <path d="M5 10l7 7 7-7H5z" />
        </svg>
    </button>

    <script
        src="https://mirrors.sustech.edu.cn/cdnjs/ajax/libs/reconnecting-websocket/1.0.0/reconnecting-websocket.min.js"
        type="application/javascript"></script>

    <script>
        const logContainer = document.getElementById('log-container');
        const scrollToBottomButton = document.getElementById('scroll-to-bottom');
        let shouldScrollToBottom = true;

        // 缓冲区相关
        let messageBuffer = [];
        let flushScheduled = false;
        const BUFFER_FLUSH_INTERVAL = 100; // 毫秒
        const BUFFER_MAX_SIZE = 50; // 最大缓冲消息数

        scrollToBottomButton.addEventListener('click', () => {
            logContainer.scrollTop = logContainer.scrollHeight;
        });

        logContainer.addEventListener('scroll', () => {
            const isAtBottom = Math.ceil(logContainer.scrollTop + logContainer.clientHeight) >= logContainer.scrollHeight;
            if (isAtBottom) {
                scrollToBottomButton.style.display = 'none';
            } else {
                scrollToBottomButton.style.display = 'block';
            }

            shouldScrollToBottom = isAtBottom;
        });

        // 刷新缓冲区到 DOM
        function flushBuffer() {
            if (messageBuffer.length === 0) {
                flushScheduled = false;
                return;
            }

            // 批量更新文本内容
            const batchText = messageBuffer.join('\n');
            logContainer.textContent += '\n' + batchText;

            // 检查状态变化（优先级：error > done > start）
            if (batchText.includes('***** ERROR *****')) {
                document.body.className = 'error';
            } else if (batchText.includes('***** DONE *****')) {
                document.body.className = 'done';
            } else if (batchText.includes('***** START TRANS *****')) {
                document.body.className = '';
            }

            // 自动滚动
            if (shouldScrollToBottom) {
                logContainer.scrollTop = logContainer.scrollHeight;
            }

            // 清空缓冲区
            messageBuffer = [];
            flushScheduled = false;
        }

        // 调度刷新
        function scheduleFlush() {
            if (!flushScheduled) {
                flushScheduled = true;
                requestAnimationFrame(() => {
                    setTimeout(flushBuffer, BUFFER_FLUSH_INTERVAL);
                });
            }
        }

        // 添加消息到缓冲区
        function bufferMessage(message) {
            messageBuffer.push(message);

            // 如果缓冲区满了，立即刷新
            if (messageBuffer.length >= BUFFER_MAX_SIZE) {
                if (flushScheduled) {
                    // 取消之前的调度，立即刷新
                    flushScheduled = false;
                }
                flushBuffer();
            } else {
                scheduleFlush();
            }
        }

        var ws = new ReconnectingWebSocket(window.location.href.replace(/^http/, 'ws'));
        ws.onopen = function () {
            bufferMessage('WebSocket Connected.');
        };
        ws.onclose = function () {
            bufferMessage('WebSocket Disconnected.');
        };
        ws.onmessage = function (event) {
            bufferMessage(event.data);
        };
    </script>
</body>

</html>
FILE_d8d3875f99acb7d0

# vendor/reinstall.sh
cat >"$FLEET_UNPACK/vendor/reinstall.sh" <<'FILE_50e8307af9bfd30c'
#!/usr/bin/env sh
# shellcheck shell=bash
# shellcheck disable=SC2086

# nixos 默认的配置不会生成 /bin/bash，因此需要用 /usr/bin/env
# alpine 默认没有 bash，因此 shebang 用 sh，再 exec 切换到 bash

set -eE
confhome=https://raw.githubusercontent.com/bin456789/reinstall/5db051675101f31bbe2fb3e093432fa4d1af8dcc
confhome_cn=''
# confhome_cn=https://www.ghproxy.cc/https://raw.githubusercontent.com/bin456789/reinstall/main

# 用于判断 reinstall.sh 和 trans.sh 是否兼容
SCRIPT_VERSION=4BACD833-A585-23BA-6CBB-9AA4E08E0004

# 记录要用到的 windows 程序，运行时输出删除 \r
WINDOWS_EXES='cmd powershell wmic reg diskpart netsh bcdedit mountvol'

BOOT_ENTEY_START_MARK='### BEGIN reinstall.sh ###'
BOOT_ENTEY_END_MARK='### END reinstall.sh ###'

# 临时目录
# 不用 /tmp，因为 /tmp 挂载在内存的话，可能不够空间
tmp=/reinstall-tmp

# 强制 linux 程序输出英文，防止 grep 不到想要的内容
# https://www.gnu.org/software/gettext/manual/html_node/The-LANGUAGE-variable.html
export LC_ALL=C

# 处理部分用户用 su 切换成 root 导致环境变量没 sbin 目录
# 也能处理 cygwin bash 没有添加 -l 运行 reinstall.sh
# 不要漏了最后的 $PATH，否则会找不到 windows 系统程序例如 diskpart
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

# 如果不是 bash 的话，继续执行会有语法错误，因此在这里判断是否 bash
if [ -z "$BASH" ] ||
    # el 的 sh 是 bash 运行在 posix 模式，依然有 $BASH 和 $BASH_VERSION
    { [ -n "$BASH" ] && [ -n "$POSIXLY_CORRECT" ]; }; then
    if ! command -v bash >/dev/null; then
        if [ -f /etc/alpine-release ]; then
            if ! apk add bash; then
                echo "Error while install bash." >&2
                exit 1
            fi
        else
            echo "Please run this script with bash." >&2
            exit 1
        fi
    fi
    exec bash "$0" "$@"
fi

# 好像跟 trap SIGINT 有冲突
# 记录日志，过滤含有 password 的行
# exec > >(tee >(grep -iv password >>/reinstall.log)) 2>&1
THIS_SCRIPT=$(readlink -f "$0")
source "${FLEET_BUNDLE:-$(dirname "$(dirname "$THIS_SCRIPT")")}/lib/adapter.sh"
trap 'trap_err $LINENO $?' ERR

trap_err() {
    line_no=$1
    ret_no=$2

    error "Line $line_no return $ret_no"
    sed -n "$line_no"p "$THIS_SCRIPT"
}

is_in_windows() {
    [ "$(uname -o)" = Cygwin ] || [ "$(uname -o)" = Msys ]
}

if is_in_windows; then
    reinstall_____='.\reinstall.bat'
else
    reinstall_____='sh reinstall.sh'
fi

usage_and_exit() {

    # kali 官网的 202x.x iso 安装后，apt 源是 rolling
    # 因此 netboot last-snapshot 没有意义
    # 因此这里不显示 last-snapshot|rolling
    cat <<EOF
Usage: $reinstall_____ anolis      7|8|23
                       opencloudos 8|9|23
                       rocky       8|9|10
                       oracle      8|9|10
                       almalinux   8|9|10
                       centos      9|10
                       fnos        1
                       fygoos      1
                       nixos       26.05
                       fedora      43|44
                       debian      9|10|11|12|13
                       opensuse    16.0|tumbleweed
                       openeuler   20.03|22.03|24.03
                       alpine      3.21|3.22|3.23|3.24
                       ubuntu      18.04|20.04|22.04|24.04|26.04 [--minimal]
                       kali
                       arch
                       gentoo
                       aosc
                       redhat      --img="http://access.cdn.redhat.com/xxx.qcow2"
                       dd          --img="http://xxx.com/yyy.zzz" (raw image stores in raw/vhd/tar/gz/xz/zst)
                       windows     --image-name="windows xxx yyy" --lang=xx-yy
                       windows     --image-name="windows xxx yyy" --iso="http://xxx.com/xxx.iso"
                       netboot.xyz
                       reset

       Options:        For Linux/Windows:
                       [--username    USERNAME]
                       [--password    PASSWORD]
                       [--ssh-key     KEY]
                       [--ssh-port    PORT]
                       [--web-port    PORT]
                       [--frpc-config PATH]

                       For Windows Only:
                       [--allow-ping]
                       [--rdp-port    PORT]
                       [--add-driver  INF_OR_DIR]

                       For Linux Only:
                       [--no-cloud-kernel]  (Debian/Ubuntu/Alpine)

       Manual:         https://github.com/bin456789/reinstall

EOF
    exit 1
}

info() {
    local msg
    if [ "$1" = false ]; then
        shift
        msg=$*
    else
        msg="***** $(to_upper <<<"$*") *****"
    fi
    echo_color_text '\e[32m' "$msg" >&2
}

warn() {
    local msg
    if [ "$1" = false ]; then
        shift
        msg=$*
    else
        msg="Warning: $*"
    fi
    echo_color_text '\e[33m' "$msg" >&2
}

error() {
    echo_color_text '\e[31m' "***** ERROR *****" >&2
    echo_color_text '\e[31m' "$*" >&2
}

echo_color_text() {
    color="$1"
    shift
    plain="\e[0m"
    echo -e "$color$*$plain"
}

error_and_exit() {
    error "$@"
    exit 1
}

show_dd_password_tips() {
    warn false "
This password is only used for SSH access to view logs during the installation.
Password of the image will NOT modify.

密码仅用于安装过程中通过 SSH 查看日志。
镜像的密码不会被修改。
"
}

show_url_in_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
        [Hh][Tt][Tt][Pp][Ss]://* | [Hh][Tt][Tt][Pp]://* | [Mm][Aa][Gg][Nn][Ee][Tt]:*) echo "$1" ;;
        esac
        shift
    done
}

curl() {
    local fleet_rc=0
    fleet_local_fetch "$@" && return 0 || fleet_rc=$?
    [ "$fleet_rc" -eq 125 ] || return "$fleet_rc"
    case " $* " in
    *" -4 "*|*" --ipv4 "*|*" -6 "*|*" --ipv6 "*) ;;
    *)
        case "${FLEET_NETWORK_TYPE:-}" in
            ipv4-only) set -- -4 "$@" ;;
            ipv6-only) set -- -6 "$@" ;;
        esac
        ;;
    esac
    is_have_cmd curl || install_pkg curl

    # 显示 url
    show_url_in_args "$@" >&2

    # 添加 -f, --fail，不然 404 退出码也为0
    # 32位 cygwin 已停止更新，证书可能有问题，先添加 --insecure
    # centos 7 curl 不支持 --retry-connrefused --retry-all-errors
    # 因此手动 retry
    for i in $(seq 5); do
        if command curl --connect-timeout 10 -f "$@"; then
            return
        else
            ret=$?
            # 403 404 错误，或者达到重试次数
            if [ $ret -eq 22 ] || [ $i -eq 5 ]; then
                return $ret
            fi
            sleep 1
        fi
    done
}

mask2cidr() {
    local x=${1##*255.}
    set -- 0^^^128^192^224^240^248^252^254^ $(((${#1} - ${#x}) * 2)) ${x%%.*}
    x=${1%%"$3"*}
    echo $(($2 + (${#x} / 4)))
}

is_in_china() {
    # Fleet uses an explicit mirror region; no geolocation dependency.
    [ "${FLEET_REGION:-global}" = cn ]
    return $?
    [ "$force_cn" = 1 ] && return 0

    if [ -z "$_loc" ]; then
        # www.cloudflare.com/dash.cloudflare.com 国内访问的是美国服务器，而且部分地区被墙
        # 没有ipv6 www.visa.cn
        # 没有ipv6 www.bose.cn
        # 没有ipv6 www.garmin.com.cn
        # 备用 www.prologis.cn
        # 备用 www.autodesk.com.cn
        # 备用 www.keysight.com.cn
        if ! _loc=$(curl -L http://www.qualcomm.cn/cdn-cgi/trace | grep '^loc=' | cut -d= -f2 | grep .); then
            error_and_exit "Can not get location."
        fi
        echo "Location: $_loc" >&2
    fi
    [ "$_loc" = CN ]
}

is_in_windows() {
    [ "$(uname -o)" = Cygwin ] || [ "$(uname -o)" = Msys ]
}

is_in_alpine() {
    [ -f /etc/alpine-release ]
}

is_use_cloud_image() {
    [ -n "$cloud_image" ] && [ "$cloud_image" = 1 ]
}

is_force_use_installer() {
    [ -n "$installer" ] && [ "$installer" = 1 ]
}

is_use_dd() {
    [ "$distro" = dd ]
}

is_boot_in_separate_partition() {
    mount | grep -q ' on /boot type '
}

is_os_in_btrfs() {
    mount | grep -q ' on / type btrfs '
}

is_os_in_subvol() {
    subvol=$(awk '($2=="/") { print $i }' /proc/mounts | grep -o 'subvol=[^ ]*' | cut -d= -f2)
    [ "$subvol" != / ]
}

get_os_part() {
    awk '($2=="/") { print $1 }' /proc/mounts
}

umount_all() {
    # windows defender 打开时，cygwin 运行 mount 很慢，但 cat /proc/mounts 很快
    if mount_lists=$(mount | grep -w "on $1" | awk '{print $3}' | grep .); then
        # alpine 没有 -R
        if umount --help 2>&1 | grep -wq -- '-R'; then
            umount -R "$1"
        else
            echo "$mount_lists" | tac | xargs -n1 umount
        fi
    fi
}

cp_to_btrfs_root() {
    mount_dir=$tmp/reinstall-btrfs-root
    if ! grep -q $mount_dir /proc/mounts; then
        mkdir -p $mount_dir
        mount "$(get_os_part)" $mount_dir -t btrfs -o subvol=/
    fi
    cp -rf "$@" "$mount_dir"
}

is_host_has_ipv4_and_ipv6() {
    host=$1

    install_pkg dig
    # dig会显示cname结果，cname结果以.结尾，grep -v '\.$' 用于去除 cname 结果
    res=$(dig +short $host A $host AAAA | grep -v '\.$')
    # 有.表示有ipv4地址，有:表示有ipv6地址
    grep -q \. <<<$res && grep -q : <<<$res
}

is_netboot_xyz() {
    [ "$distro" = netboot.xyz ]
}

is_alpine_live() {
    [ "$distro" = alpine ] && [ "$hold" = 1 ]
}

is_have_initrd() {
    ! is_netboot_xyz
}

is_use_firmware() {
    # shellcheck disable=SC2154
    [ "$nextos_distro" = debian ] && ! is_virt
}

is_digit() {
    [[ "$1" =~ ^[0-9]+$ ]]
}

is_port_valid() {
    is_digit "$1" && [ "$1" -ge 1 ] && [ "$1" -le 65535 ]
}

get_host_by_url() {
    cut -d/ -f3 <<<$1
}

get_scheme_and_host_by_url() {
    cut -d/ -f1-3 <<<$1
}

get_function() {
    declare -f "$1"
}

get_function_content() {
    declare -f "$1" | sed '1d;2d;$d'
}

insert_into_file() {
    local file=$1
    local location=$2
    local regex_to_find=$3
    shift 3

    if ! [ -f "$file" ]; then
        error_and_exit "File not found: $file"
    fi

    # 默认 grep -E
    if [ $# -eq 0 ]; then
        set -- -E
    fi

    line_num=$(grep "$@" -n "$regex_to_find" "$file" | cut -d: -f1)

    found_count=$(echo "$line_num" | wc -l)
    if [ ! "$found_count" -eq 1 ]; then
        return 1
    fi

    case "$location" in
    before) line_num=$((line_num - 1)) ;;
    after) ;;
    *) return 1 ;;
    esac

    sed -i "${line_num}r /dev/stdin" "$file"
}

test_url() {
    test_url_real false "$@"
}

test_url_grace() {
    test_url_real true "$@"
}

test_url_real() {
    grace=$1
    url=$2
    expect_types=$3
    var_to_eval=$4
    fleet_family_arg=
    case "${FLEET_NETWORK_TYPE:-}" in
        ipv4-only) fleet_family_arg=-4 ;;
        ipv6-only) fleet_family_arg=-6 ;;
    esac
    info test url

    failed() {
        $grace && return 1
        error_and_exit "$@"
    }

    tmp_file=$tmp/img-test

    # TODO: 好像无法识别 nixos 官方源的跳转
    # 有的服务器不支持 range，curl会下载整个文件
    # 所以用 head 限制 1M
    # 过滤 curl 23 错误（head 限制了大小）
    # 也可用 ulimit -f 但好像 cygwin 不支持
    # ${PIPESTATUS[n]} 表示第n个管道的返回值
    echo $url
    for i in $(seq 5 -1 0); do
        if command curl $fleet_family_arg --connect-timeout 10 -Lfr 0-1048575 "$url" \
            1> >(exec head -c 1048576 >$tmp_file) \
            2> >(exec grep -v 'curl: (23)' >&2); then
            break
        else
            ret=$?
            msg="$url not accessible"
            case $ret in
            22)
                # 403 404
                # 这里的 failed 虽然返回 1，但是不会中断脚本，因此要手动 return
                failed "$msg"
                return "$ret"
                ;;
            23)
                # 限制了空间
                break
                ;;
            *)
                # 其他错误
                if [ $i -eq 0 ]; then
                    failed "$msg"
                    return "$ret"
                fi
                ;;
            esac
            sleep 1
        fi
    done

    # 如果要检查文件类型
    if [ -n "$expect_types" ]; then
        install_pkg file
        real_type=$(file_enhanced $tmp_file)
        echo "File type: $real_type"

        # debian 9 ubuntu 16.04-20.04 可能会将 iso 识别成 raw
        for type in $expect_types $([ "$expect_types" = iso ] && echo raw); do
            if [[ ."$real_type" = *."$type" ]]; then
                # 如果要设置变量
                if [ -n "$var_to_eval" ]; then
                    IFS=. read -r "${var_to_eval?}" "${var_to_eval}_warp" <<<"$real_type"
                fi
                return
            fi
        done

        failed "$url
Expected type: $expect_types
Actually type: $real_type"
    fi
}

fix_file_type() {
    # gzip的mime有很多种写法
    # centos7中显示为 x-gzip，在其他系统中显示为 gzip，可能还有其他
    # 所以不用mime判断
    # https://www.digipres.org/formats/sources/tika/formats/#application/gzip

    # centos 7 上的 file 显示 qcow2 的 mime 为 application/octet-stream
    # file debian-12-genericcloud-amd64.qcow2
    # debian-12-genericcloud-amd64.qcow2: QEMU QCOW Image (v3), 2147483648 bytes
    # file --mime debian-12-genericcloud-amd64.qcow2
    # debian-12-genericcloud-amd64.qcow2: application/octet-stream; charset=binary

    # --extension 不靠谱
    # file -b /reinstall-tmp/img-test --mime-type
    # application/x-qemu-disk
    # file -b /reinstall-tmp/img-test --extension
    # ???

    # 1. 删除,;#
    # DOS/MBR boot sector; partition 1: ...
    # gzip compressed data, was ...
    # # ISO 9660 CD-ROM filesystem data... (有些 file 版本开头输出有井号)

    # 2. 删除开头的空格

    # 3. 删除无意义的单词 POSIX, Unicode, UTF-8, ASCII
    # POSIX tar archive (GNU)
    # Unicode text, UTF-8 text
    # UTF-8 Unicode text, with very long lines
    # ASCII text

    # 4. 下面两种都是 raw
    # DOS/MBR boot sector
    # x86 boot sector; partition 1: ...
    sed -E \
        -e 's/[,;#]//g' \
        -e 's/^[[:space:]]*//' \
        -e 's/(POSIX|Unicode|UTF-8|ASCII)//gi' \
        -e 's/^DOS\/MBR boot sector/raw/i' \
        -e 's/^x86 boot sector/raw/i' \
        -e 's/^Zstandard/zstd/i' \
        -e 's/^UDF/iso/i' \
        -e 's/^Windows imaging \(WIM\) image/wim/i' |
        awk '{print $1}' | to_lower
}

# 不用 file -z，因为
# 1. file -z 只能看透一层
# 2. alpine file -z 无法看透部分镜像（前1M），例如：
# guajibao-win10-ent-ltsc-2021-x64-cn-efi.vhd.gz
# guajibao-win7-sp1-ent-x64-cn-efi.vhd.gz
# win7-ent-sp1-x64-cn-efi.vhd.gz
# 还要注意 centos 7 没有 -Z 只有 -z
file_enhanced() {
    file=$1

    full_type=
    while true; do
        type="$(file -b $file | fix_file_type)"
        full_type="$type.$full_type"
        case "$type" in
        xz | gzip | zstd)
            install_pkg "$type"
            $type -dc <"$file" | head -c 1048576 >"$file.inside"
            mv -f "$file.inside" "$file"
            ;;
        tar)
            install_pkg "$type"
            # 隐藏 gzip: unexpected end of file 提醒
            tar xf "$file" -O 2>/dev/null | head -c 1048576 >"$file.inside"
            mv -f "$file.inside" "$file"
            ;;
        *)
            break
            ;;
        esac
    done
    # shellcheck disable=SC2001
    echo "$full_type" | sed 's/\.$//'
}

# trans.sh 有相同方法
add_community_repo_for_alpine() {
    local ver mirror

    # 先检查原来的 repo 是不是 edge 或者 latest-stable
    if grep -q "^http.*/edge/main$" /etc/apk/repositories; then
        ver=edge
    elif grep -q "^http.*/latest-stable/main$" /etc/apk/repositories; then
        ver=latest-stable
    else
        ver=v$(cut -d. -f1,2 </etc/alpine-release)
    fi

    if ! grep -q "^http.*/$ver/community$" /etc/apk/repositories; then
        mirror=$(grep '^http.*/main$' /etc/apk/repositories | sed 's,/[^/]*/main$,,' | head -1)
        echo $mirror/$ver/community >>/etc/apk/repositories
    fi
}

is_in_container() {
    { is_have_cmd systemd-detect-virt && systemd-detect-virt -qc; } ||
        [ -d /proc/vz ] ||
        { [ -f /proc/1/environ ] && grep -q container=lxc /proc/1/environ; }
}

# 使用 | del_br ，但返回 del_br 之前返回值
run_with_del_cr() {
    if false; then
        # ash 不支持 PIPESTATUS[n]
        res=$("$@") && ret=0 || ret=$?
        echo "$res" | del_cr
        return $ret
    else
        "$@" | del_cr
        return ${PIPESTATUS[0]}
    fi
}

run_with_del_cr_template() {
    if get_function _$exe >/dev/null; then
        run_with_del_cr _$exe "$@"
    else
        run_with_del_cr command $exe "$@"
    fi
}

wmic() {
    if is_have_cmd wmic; then
        # 如果参数没有 GET，添加 GET，防止以下报错
        # wmic memorychip /format:list
        # 此级别的开关异常。
        has_get=false
        for i in "$@"; do
            # 如果参数有 GET
            if [ "$(to_upper <<<"$i")" = GET ]; then
                has_get=true
                break
            fi
        done

        # 输出为 /format:list 格式
        if $has_get; then
            command wmic "$@" /format:list
        else
            command wmic "$@" get /format:list
        fi
        return
    fi

    # powershell wmi 默认参数
    local namespace='root\cimv2'
    local class=
    local filter=
    local props=

    # namespace
    if [[ "$(to_upper <<<"$1")" = /NAMESPACE* ]]; then
        # 删除引号，删除 \\
        namespace=$(cut -d: -f2 <<<"$1" | sed -e "s/[\"']//g" -e 's/\\\\//g')
        shift
    fi

    # class
    if [[ "$(to_upper <<<"$1")" = PATH ]]; then
        class=$2
        shift 2
    else
        # wmic alias list brief
        case "$(to_lower <<<"$1")" in
        nicconfig) class=Win32_NetworkAdapterConfiguration ;;
        memorychip) class=Win32_PhysicalMemory ;;
        *) class=Win32_$1 ;;
        esac
        shift
    fi

    # filter
    if [[ "$(to_upper <<<"$1")" = WHERE ]]; then
        filter=$2
        shift 2
    fi

    # props
    if [[ "$(to_upper <<<"$1")" = GET ]]; then
        props=$2
        shift 2
    fi

    if ! [ -f "$tmp/wmic.ps1" ]; then
        curl -Lo "$tmp/wmic.ps1" "$confhome/wmic.ps1"
    fi

    powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass \
        -File "$(cygpath -w "$tmp/wmic.ps1")" \
        -Namespace "$namespace" \
        -Class "$class" \
        ${filter:+"-Filter"} ${filter:+"$filter"} \
        ${props:+"-Properties"} ${props:+"$props"}
}

is_virt() {
    if [ -z "$_is_virt" ]; then
        if is_in_windows; then
            # https://github.com/systemd/systemd/blob/main/src/basic/virt.c
            # https://sources.debian.org/src/hw-detect/1.159/hw-detect.finish-install.d/08hw-detect/
            vmstr='VMware|VirtualBox|VMW|Hyper-V|Bochs|QEMU|KVM|OpenStack|KubeVirt|innotek|Xen|HVM|Parallels|BHYVE|OVMF'
            vmstr+='|virt|Virtual|Virtualization'
            for name in ComputerSystem BIOS BaseBoard; do
                if wmic $name | grep -Eiw $vmstr; then
                    _is_virt=true
                    break
                fi
            done

            # 用运行 windows ，肯定够内存运行 alpine lts netboot
            # 何况还能停止 modloop

            # 没有风扇和温度信息，大概是虚拟机
            # 阿里云 倚天710 arm 有温度传感器
            # ovh KS-LE-3 没有风扇和温度信息？
            if false && [ -z "$_is_virt" ] &&
                ! wmic /namespace:'\\root\cimv2' PATH Win32_Fan 2>/dev/null | grep -q ^Name &&
                ! wmic /namespace:'\\root\wmi' PATH MSAcpi_ThermalZoneTemperature 2>/dev/null | grep -q ^Name; then
                _is_virt=true
            fi
        else
            # aws t4g debian 11
            # systemd-detect-virt: 为 none，即使装了dmidecode
            # virt-what: 未装 deidecode时结果为空，装了deidecode后结果为aws
            # 所以综合两个命令的结果来判断
            if is_have_cmd systemd-detect-virt && systemd-detect-virt -v; then
                _is_virt=true
            fi

            if [ -z "$_is_virt" ]; then
                # debian 安装 virt-what 不会自动安装 dmidecode，因此结果有误
                install_pkg dmidecode virt-what
                # virt-what 返回值始终是0，所以用是否有输出作为判断
                if [ -n "$(virt-what)" ]; then
                    _is_virt=true
                fi
            fi
        fi

        if [ -z "$_is_virt" ]; then
            _is_virt=false
        fi
        echo "VM: $_is_virt"
    fi
    $_is_virt
}

is_cpu_supports_x86_64_v3() {
    # 用 ld.so/cpuid/coreinfo.exe 更准确
    # centos 7 /usr/lib64/ld-linux-x86-64.so.2 没有 --help
    # alpine gcompat /lib/ld-linux-x86-64.so.2 没有 --help

    # https://en.wikipedia.org/wiki/X86-64#Microarchitecture_levels
    # https://learn.microsoft.com/sysinternals/downloads/coreinfo

    # abm = popcnt + lzcnt
    # /proc/cpuinfo 不显示 lzcnt, 可用 abm 代替，但 cygwin 也不显示 abm
    # /proc/cpuinfo 不显示 osxsave, 故用 xsave 代替

    need_flags="avx avx2 bmi1 bmi2 f16c fma movbe xsave"
    had_flags=$(grep -m 1 ^flags /proc/cpuinfo | awk -F': ' '{print $2}')

    for flag in $need_flags; do
        if ! grep -qw $flag <<<"$had_flags"; then
            return 1
        fi
    done
}

assert_cpu_supports_x86_64_v3() {
    if ! is_cpu_supports_x86_64_v3; then
        error_and_exit "Could not install $distro $releasever because the CPU does not support x86-64-v3."
    fi
}

get_http_log_url() {
    echo "http://IP$([ "${web_port:-80}" = 80 ] || echo :$web_port)$web_path"
}

# 判断语言字符是否合法，允许全名和缩写
is_valid_lang_chars() {
    [[ "$1" =~ ^[A-Za-z_-]+$ ]]
}

lang_convert() {
    local out_format=$1
    local in=$lang

    if ! is_valid_lang_chars "$in"; then
        return
    fi

    # 如果是 fallback_ 开头的，先得到 fallback 后的 cc-cc
    if [[ "$out_format" = fallback_* ]]; then
        in=$(lang_convert_inner "$in" fallback_cc-cc)
        # 如果要输出 fallback_cc-cc ，直接输出
        if [ "$out_format" = fallback_cc-cc ]; then
            printf '%s' "$in"
            return
        fi
        # 去除 fallback_ 前缀
        out_format=${out_format#fallback_}
    fi

    # 尝试转换成目标格式
    local out
    out=$(lang_convert_inner "$in" "$out_format")

    # 如果转换成功，则表示输入的语言在列表里面
    if [ -n "$out" ]; then
        printf '%s' "$out"
    else
        # 如果没有，则手动截取
        case "$out_format" in
        cc) cut -d- -f1 <<<"$in" ;;
        cc-cc) cut -d- -f1-2 <<<"$in" ;;
        cc-cc-cc) cut -d- -f1-3 <<<"$in" ;;
        esac
    fi
}

lang_convert_inner() {
    local in=$1
    local out_format=$2

    if ! is_valid_lang_chars "$in"; then
        return
    fi

    # 可能得到 / ，用 is_valid_lang_chars 过滤掉
    local out
    if out=$(
        lang_table_with_head | sed 1d | to_lower | awk \
            -v val="$in" \
            -v c1="$(get_col_number cc)" \
            -v c2="$(get_col_number cc-cc)" \
            -v c3="$(get_col_number cc-cc-cc)" \
            -v c4="$(get_col_number full_language)" \
            -v cout="$(get_col_number "$out_format")" \
            '$c1 == val || $c2 == val || $c3 == val || $c4 == val { print $cout }'
    ) && is_valid_lang_chars "$out"; then
        printf '%s' "$out"
    fi
}

get_col_number() {
    local col_name=$1

    # 找出第一行，用 xargs -n 1 转成列，然后用 grep 找到行号，再用 cut 取出行号
    lang_table_with_head | head -1 | xargs -n 1 | grep -Fxn "$col_name" | cut -d: -f1
}

lang_table_with_head() {
    # 没有 gb mx 开头的镜像，列出它们作用是，用户输入时识别成 en-gb es-mx
    # ca 并非对应 fr-ca
    # pt 对应 pt-br，而不是 pt-pt
    # uk 对应乌克兰语而不是英国，如果用户输入 uk ，要识别成乌克兰
    # 第 5 列是可回落的语言
    cat <<EOF
cc  cc-cc    cc-cc-cc    full_language     fallback_cc-cc
ar  ar-sa        /       Arabic
bg  bg-bg        /       Bulgarian
cs  cs-cz        /       Czech
da  da-dk        /       Danish
de  de-de        /       German
el  el-gr        /       Greek
gb  en-gb        /       Eng_Intl           en-us
en  en-us        /       English
es  es-es        /       Spanish
mx  es-mx        /       Spanish_Latam
et  et-ee        /       Estonian
fi  fi-fi        /       Finnish
/   fr-ca        /       FrenchCanadian     fr-fr
fr  fr-fr        /       French
he  he-il        /       Hebrew
hr  hr-hr        /       Croatian
hu  hu-hu        /       Hungarian
it  it-it        /       Italian
ja  ja-jp        /       Japanese
ko  ko-kr        /       Korean
lt  lt-lt        /       Lithuanian
lv  lv-lv        /       Latvian
no  nb-no        /       Norwegian
nl  nl-nl        /       Dutch
pl  pl-pl        /       Polish
pp  pt-pt        /       Portuguese
pt  pt-br        /       Brazilian          pt-pt
ro  ro-ro        /       Romanian
ru  ru-ru        /       Russian
sk  sk-sk        /       Slovak
sl  sl-si        /       Slovenian
sr  sr-latn  sr-latn-rs  Serbian_Latin
sv  sv-se        /       Swedish
th  th-th        /       Thai
tr  tr-tr        /       Turkish
uk  uk-ua        /       Ukrainian
cn  zh-cn        /       ChnSimp
tw  zh-tw        /       ChnTrad
hk  zh-hk        /       ChnTrad_Hong_Kong  zh-tw
EOF
}

parse_windows_image_name() {
    # 将名称改成内部名称
    # home basic 改为 homebasic
    # home premium 改为 homepremium
    # windows server 2008 server 改为 windows longhorn server
    # 注意 windows server 2008 r2 serverdatacenter 不用改
    image_name=$(
        <<<"$image_name" sed \
            -e 's/^windows server 2008 server/windows longhorn server/' \
            -e 's/home basic$/homebasic/' \
            -e 's/home premium$/homepremium/'
    )

    set -- $image_name

    if ! [ "$1" = windows ]; then
        return 1
    fi
    shift

    if [ "$1" = server ]; then
        server=server
        shift
    fi

    version=$1
    shift

    if [ "$1" = r2 ]; then
        version+=" r2"
        shift
    fi

    edition=
    while [ $# -gt 0 ]; do
        case "$1" in
        # windows 10 enterprise n ltsc 2021
        k | n | kn) ;;
        *)
            if [ -n "$edition" ]; then
                edition+=" "
            fi
            edition+="$1"
            ;;
        esac
        shift
    done

    # longhorn 改成 server 2008 用于 iso 查找
    if [ "$version" = longhorn ] && [[ "$edition" = server* ]]; then
        server=server
        version=2008
    fi
}

is_have_arm64_version() {
    case "$version" in
    # win8.x 有 arm32 版本，但是我们不支持 arm32
    10)
        case "$edition" in
        home | 'home single language' | pro | education | enterprise | 'pro education' | 'pro for workstations') return ;;
        'iot enterprise') return ;;
        # arm ltsc 只有 2021 有 iso
        'enterprise ltsc 2021' | 'iot enterprise ltsc 2021') return ;;
        esac
        ;;
    11)
        return
        ;;
    esac
    return 1
}

find_windows_iso() {
    parse_windows_image_name || error_and_exit "--image-name wrong: $image_name"
    if ! { [ "$version" = 8 ] || [ "$version" = 8.1 ]; } && [ -z "$edition" ]; then
        error_and_exit "Windows Edition is not specified."
    fi

    if [ -z "$lang" ]; then
        lang=en-us
    fi

    # 用户输入的语言最优先
    langs=$lang
    langs+=" $(lang_convert cc-cc-cc)          $(lang_convert cc-cc)          $(lang_convert cc)"
    langs+=" $(lang_convert fallback_cc-cc-cc) $(lang_convert fallback_cc-cc) $(lang_convert fallback_cc)"
    langs=$(xargs -n 1 <<<"$langs" | awk '!seen[$0]++' | xargs)

    full_langs="$(lang_convert full_language) $(lang_convert fallback_full_language)"
    full_langs=$(xargs -n 1 <<<"$full_langs" | awk '!seen[$0]++' | xargs)

    case "$basearch" in
    x86) # 备用，查找功能目前不支持 32 位
        arch_win=x86
        arch_win_vlsc='32-?bit'
        ;;
    x86_64)
        arch_win=x64
        arch_win_vlsc='64-?bit'
        ;;
    aarch64)
        arch_win=arm64
        arch_win_vlsc=arm64
        ;;
    esac

    get_windows_iso_link
}

get_windows_iso_link() {
    get_label_msdn() {
        case "$version" in
        vista)
            case "$edition" in
            starter)
                case "$arch_win" in
                x86) echo _ ;;
                esac
                ;;
            homebasic | homepremium | ultimate)
                echo _
                ;;
            business | enterprise)
                # ntriver 的 iso 是 vlsc 的
                ;;
            esac
            ;;
        7)
            case "$edition" in
            starter)
                case "$arch_win" in
                x86) echo starter ;;
                esac
                ;;
            homebasic)
                case "$arch_win" in
                # ntriver 没有单独的 win7 homebasic x64 iso
                # 可从 homepremium iso 获取
                x86) echo "home basic" ;;
                x64) echo "home premium" ;;
                esac
                ;;
            homepremium)
                echo "home premium"
                ;;
            professional | enterprise | ultimate)
                echo "$edition"
                ;;
            esac
            ;;
        8 | 8.1)
            case "$edition" in
            '') # windows 8.x core
                echo _
                ;;
            pro | enterprise)
                echo "$edition"
                ;;
            esac
            ;;
        10)
            case "$edition" in
            home | 'home single language')
                echo 'consumer editions'
                ;;
            pro | enterprise)
                echo 'business editions'
                ;;
            education | 'pro education' | 'pro for workstations')
                case "$arch_win" in
                arm64) echo 'consumer editions' ;;     # 只能从 consumer 获取
                x86 | x64) echo 'business editions' ;; # iso 更小
                esac
                ;;
            # iot
            'iot enterprise')
                echo 'iot enterprise'
                ;;
            # ltsc
            'enterprise 2015 ltsb' | 'enterprise 2016 ltsb' | 'enterprise ltsc 2019' | 'enterprise ltsc 2021')
                case "$arch_win" in
                arm64) echo "iot $edition" ;; # 只能从 iot ltsc iso 获取
                x86 | x64) echo "$edition" ;;
                esac
                ;;
            # iot ltsc
            'iot enterprise 2015 ltsb' | 'iot enterprise 2016 ltsb' | 'iot enterprise ltsc 2019' | 'iot enterprise ltsc 2021')
                echo "$edition"
                ;;
            esac
            ;;
        11)
            case "$edition" in
            home | 'home single language')
                echo 'consumer editions'
                ;;
            pro | enterprise)
                echo 'business editions'
                ;;
            education | 'pro education' | 'pro for workstations')
                # arm business iso 都没有 education, pro education, pro for workstations
                # 即使它的名字包含 EDU
                # SW_DVD9_Win_Pro_10_22H2.31_Arm64_English_Pro_Ent_EDU_N_MLF_X24-05074.ISO
                # en-us_windows_11_business_editions_version_25h2_arm64_dvd_8afc9b39.iso
                case "$arch_win" in
                arm64) echo 'consumer editions' ;; # 只能从 consumer 获取
                x64) echo 'business editions' ;;   # iso 更小
                esac
                ;;
            # iot
            'iot enterprise' | 'iot enterprise subscription')
                echo 'iot enterprise'
                ;;
            # ltsc
            'enterprise ltsc 2024')
                case "$arch_win" in
                arm64) echo "iot $edition" ;; # 只能从 iot ltsc iso 获取
                x64) echo "$edition" ;;
                esac
                ;;
            # iot ltsc
            'iot enterprise ltsc 2024' | 'iot enterprise subscription ltsc 2024')
                echo 'iot enterprise ltsc 2024'
                ;;
            esac
            ;;
        2008 | '2008 r2')
            case "$edition" in
            serverweb | serverwebcore) echo _ ;;
            serverstandard | serverstandardcore) echo _ ;;
            serverenterprise | serverenterprisecore) echo _ ;;
            serverdatacenter | serverdatacentercore) echo _ ;;
            esac
            ;;
        2012 | '2012 r2' | 2016 | 2019 | 2022 | 2025)
            case "$edition" in
            serverstandard | serverstandardcore) echo _ ;;
            serverdatacenter | serverdatacentercore) echo _ ;;
            esac
            ;;
        esac
    }

    get_label_vlsc() {
        case "$version" in
        # SW_DVD9_Win_Pro_11_25H2_Arm64_Arabic_Pro_Ent_EDU_N_MLF_X24-13113.iso

        # SW_DVD5_WIN_ENT_LTSB_10_2015_64BIT_Arabic_MLF_X20-26578.ISO
        # SW_DVD5_WIN_ENT_LTSB_2016_64BIT_Arabic_MLF_X21-07425.ISO
        # SW_DVD5_WIN_ENT_LTSC_2019_64-bit_Arabic_MLF_X21-96407.ISO
        # SW_DVD9_WIN_ENT_LTSC_2021_64BIT_ChnSimp_MLF_X22-84402.ISO
        # SW_DVD9_WIN_ENT_LTSC_2024_64-bit_Arabic_MLF_X23-70037.ISO

        # SW_DVD5_Win_10_IOT_Enterprise_2015_LTSB_64Bit_EMB_English_OEM_X20-20063.IMG
        # SW_DVD5_Win10_IoT_Enterprise_LTSB_1607_64-bit_EMB_English_OEM_X21-05293.IMG
        # SW_DVD9_Win_11_IoT_Enterprise_LTSC_24H2_64-Bit_English_X23-70076.ISO
        vista)
            case "$edition" in
            business | enterprise) echo "$edition" ;;
            esac
            ;;
        10)
            case "$edition" in
            pro | education | enterprise | 'pro education' | 'pro for workstations') echo pro ;;
            'enterprise 2015 ltsb') echo 'ent ltsb 10 2015' ;;
            'enterprise 2016 ltsb') echo 'ent ltsb 2016' ;;
            'enterprise ltsc 2019') echo 'ent ltsc 2019' ;;
            'enterprise ltsc 2021') echo 'ent ltsc 2021' ;;
            'iot enterprise 2015 ltsb') echo 'iot enterprise 2015 ltsb' ;; # √
            'iot enterprise 2016 ltsb') echo 'iot enterprise ltsb 1607' ;; # √
            'iot enterprise ltsc 2019') echo 'iot enterprise ltsc 2019' ;; # 没找到
            'iot enterprise ltsc 2021') echo 'iot enterprise ltsc 2021' ;; # 没找到
            esac
            ;;
        11)
            case "$edition" in
            pro | education | enterprise | 'pro education' | 'pro for workstations') echo pro ;;
            'enterprise ltsc 2024') echo 'ent ltsc 2024' ;;
            'iot enterprise ltsc 2024' | 'iot enterprise subscription ltsc 2024') echo 'iot enterprise ltsc 24h2' ;; # √
            esac
            ;;
        esac
    }

    # msdl 没有每月发布的 iso
    # msdl 只有 consumer 版本，因此里面的 pro 版本不是 vl 版
    # 8.1 没有每月发布的 iso，因此优先从 msdl 下载
    # win10 22h2 arm 有每月发布的 iso，因此不从 msdl 下载
    # win10/11 ltsc 没有每月发布的 iso，但是 msdl 没有 ltsc 版本
    get_label_msdl() {
        :
    }

    get_page_url() {
        if [ "$server" = 'server' ]; then
            echo https://ntriver.org/download-windows-server-${version/ /-}
        elif is_ltsc; then
            echo https://ntriver.org/download-windows-ltsc
        else
            echo https://ntriver.org/download-windows-$version
        fi
    }

    is_ltsc() {
        grep -Ewq 'ltsb|ltsc' <<<"$edition"
    }

    # 部分 bash 例如 ubuntu 22.04 不支持 $() 里面嵌套case，所以定义成函数
    label_msdn=$(get_label_msdn)
    label_msdl=$(get_label_msdl)
    label_vlsc=$(get_label_vlsc)
    page_url=$(get_page_url)

    info "Find windows iso"
    echo "Version:    $version"
    echo "Edition:    $edition"
    echo "Label msdn: $label_msdn"
    echo "Label msdl: $label_msdl"
    echo "Label vlsc: $label_vlsc"
    echo "Page:       $page_url"
    echo "Languages:  $langs $full_langs"
    echo

    # 先判断是否能自动查找该版本
    # 再判断是否支持 arm
    # 这样可以在输入错误 Edition 时例如 windows 11 enterprise ltsc 2021
    # 显示名称错误，而不是显示该版本不支持 arm

    if [ -z "$page_url" ] || { [ -z "$label_msdn" ] && [ -z "$label_msdl" ] && [ -z "$label_vlsc" ]; }; then
        error_and_exit "Not support find this iso. Check if --image-name is wrong. Or set --iso manually."
    fi

    if [ "$basearch" = aarch64 ] && ! is_have_arm64_version; then
        error_and_exit "No ARM64 iso for this Windows Version or Edition."
    fi

    if [ -n "$label_msdl" ]; then
        iso=$(curl -L "$page_url" | grep -ioP 'https://[^ ]+?#[0-9]+' | head -1 | grep .)
    else
        http_to_host=$(get_scheme_and_host_by_url "$page_url")
        http_to_current_dir=$(dirname "$page_url")

        curl -L "$page_url" | tr -d '\n' | # 合成一行
            if [[ "$page_url" =~ massgrave.dev ]]; then
                sed -e 's,<a ,\n<a ,g' -e 's,</a>,</a>\n,g' |         # 使每个 <a></a> 占一行
                    grep -Ei '\.(iso|img)</a>$' |                     # 找出是 iso 或 img 的行
                    sed -E 's,<a href="?([^" ]+)"?.+>(.+)</a>,\2 \1,' # 提取文件名和链接
            else
                sed -e 's,<td><strong>,\n<td><strong>,g' -e 's,</a>,</a>\n,g' |   # 使每个镜像占一行
                    grep -Ei '\.(iso|img)</strong>' |                             # 找出是 iso 或 img 的行
                    sed -E 's,<td><strong>([^<]+).+<a href="?([^" ]+)"?.+,\1 \2,' # 提取文件名和链接
            fi |

            # 如果链接是 / 开头，则补全域名
            # 如果链接非 https:// 开头，则补全域名和目录
            sed -E "s, (/), $http_to_host\1," |
            awk '{if ($2 !~ /^https?:\/\//) $2 = "'$http_to_current_dir/'" $2; print}' |

            # 如果不是 ltsc ，应该先去除 ltsc 链接，否则最终链接有 ltsc 的
            # 例如查找 windows 10 iot enterprise，会得到
            # en-us_windows_10_iot_enterprise_ltsc_2021_arm64_dvd_e8d4fc46.iso
            # en-us_windows_10_iot_enterprise_version_22h2_arm64_dvd_39566b6b.iso
            if is_ltsc; then
                grep -Ei '_lts[bc]_'
            else
                grep -Ei -v '_lts[bc]_'
            fi >$tmp/win.list

        get_windows_iso_link_inner
    fi
}

get_shortest_line() {
    awk '(NR == 1 || length($0) < length(shortest)) { shortest = $0 } END { print shortest }'
}

get_shortest_line_by_field() {
    local field=$1
    awk "(NR == 1 || length(\$$field) < length(field)) { line = \$0; field = \$$field } END { print line }"
}

get_best_windows_iso_line() {
    local lines
    lines=$(cat)

    # 排除 debug 版
    lines=$(echo "$lines" | grep -Ei -v '_(symbols|debug|debugging|checked)_')

    # 在所有符合的 iso 中
    # 先选择 win10/11 大版本更新的 (version 26h1) 或者有 sp 版本的 (sp1, windows_8.1_with_update_)
    # 再选择有日期更新的 (updated_july_2026)
    # 再选择 vl
    # 再按版本号排序选择最新版

    # 但是也有例外
    # zh-cn_windows_server_2019_x64_dvd_19d65722.iso                    2022-11-15
    # cn_windows_server_2019_updated_april_2021_x64_dvd_a6dae187.iso    2021-04-20

    for key in '(version_[0-9h]{4}|sp[1-9]|service_pack|with_update)' 'updated' 'vl'; do
        if grep_lines=$(grep -Ei "_${key}_" <<<"$lines"); then
            lines=$grep_lines
        fi
    done

    echo "$lines" | sort -Vr | head -1
}

get_windows_iso_link_inner() {
    regexs=()

    # msdn
    if [ -n "$label_msdn" ]; then
        if [ "$label_msdn" = _ ]; then
            label_msdn=
        fi
        for lang in $langs; do
            # en_windows_vista_sp2_x64_dvd_342267.iso
            # cn_windows_vista_with_sp2_x64_dvd_x15-36322.iso
            # en_windows_8_x64_dvd_915440.iso
            # en_windows_8.1_pro_vl_with_update_x64_dvd_6050880.iso
            # en_windows_8.1_with_update_x64_dvd_6051480.iso
            # en_windows_8.1_n_with_update_x64_dvd_6051677.iso
            # en-us_windows_10_iot_enterprise_version_22h2_arm64_dvd_39566b6b.iso
            # en-us_windows_11_consumer_editions_version_26h1_updated_july_2026_x64_dvd_f69a9a1e.iso
            # en-us_windows_server_2025_updated_july_2026_x64_dvd_4e6f5a42.iso
            local prefix=
            for i in ${lang} windows ${server} ${version} ${label_msdn}; do
                if [ -n "$i" ]; then
                    prefix+="${i}_"
                fi
            done

            # 用于准确匹配，例如防止 2012 匹配到 2012 r2
            # 首先匹配 label 后面紧接着这些关键字的
            # 然后匹配 label 后面紧接着 x64/arm64 的
            # 最后模糊匹配
            regexs+=("${prefix}(version|vl|with|updated|sp[0-9])_.*${arch_win}.*\.(iso|img)")
            regexs+=("${prefix}${arch_win}.*\.(iso|img)")
            regexs+=("${prefix}.*${arch_win}.*\.(iso|img)")
        done
    fi

    # vlsc
    # SW_DVD5_Windows_Vista_Business_64BIT_Arabic_Full_Int_SP2_MLF_X15-40038.ISO
    # SW_DVD5_SA_Win_Vista_Enterprise_64BIT_Arabic_Full_Int_SP2_MLF_X15-40408.ISO
    # SW_DVD5_Win_10_IOT_Enterprise_2015_LTSB_64Bit_EMB_English_OEM_X20-20063.IMG
    # SW_DVD9_Win_Pro_10_22H2.15_Arm64_English_Pro_Ent_EDU_N_MLF_X23-67223.ISO
    # SWDVD9_WinSrvSTDCORE2025_24H2.16_64Bit_English_DC_STD_MLF_RTMUpdJan26_X24-26760.iso

    # 先判断 full_lang 是否为空
    # 因为假如用户输入的 lang 不正确，full_lang 就为空，正则表达式就无法只匹配当前语言
    for full_lang in $full_langs; do
        if [ -n "$label_vlsc" ] && [ -n "$full_lang" ]; then
            regexs+=("sw_?dvd[59]_(SA_)?win(dows)?_?${label_vlsc}_?${version}_.*${arch_win_vlsc}.*_${full_lang}.*\.(iso|img)")
            regexs+=("sw_?dvd[59]_(SA_)?win_?(dows)?${version}_${label_vlsc}_?.*${arch_win_vlsc}.*_${full_lang}.*\.(iso|img)")
            # LTSC 没有 windows 主版本号
            # SW_DVD5_WIN_ENT_LTSB_10_2015_64BIT_Arabic_MLF_X20-26578.ISO # 将 ENT_LTSB_10_2015 视为 label
            # SW_DVD5_WIN_ENT_LTSB_2016_64BIT_Arabic_MLF_X21-07425.ISO    # 将 ENT_LTSB_2016    视为 label
            if is_ltsc; then
                regexs+=("sw_?dvd[59]_(SA_)?win(dows)?_?${label_vlsc}_?.*${arch_win_vlsc}.*_${full_lang}.*\.(iso|img)")
            fi
        fi
    done

    # 查找
    for regex in "${regexs[@]}"; do
        regex=${regex// /_}

        echo "looking for: $regex" >&2
        local matched_lines
        if matched_lines=$(grep -Ei "^$regex " "$tmp/win.list"); then
            info "ISO Matched"
            cat -n <<<"$matched_lines" >&2
            if line=$(echo "$matched_lines" | get_best_windows_iso_line | grep .) &&
                iso=$(awk '{print $2}' <<<"$line" | grep .); then
                info "ISO Selected"
                echo "        $line" >&2
                return
            fi
        fi
    done

    error_and_exit "Could not find iso for this windows edition or language."
}

set_var() {
    # eval 不安全

    # 仅 bash 可用
    printf -v "$1" "%s" "$2"

    # 或者
    # IFS= read -r "$1" <<<"$2"
}

setos() {
    local step=$1
    local distro=$2
    local releasever=$3
    info set $step $distro $releasever

    set_osvar() {
        set_var "${step}_$1" "$2"
    }

    setos_netboot.xyz() {
        if is_efi; then
            if [ "$basearch" = aarch64 ]; then
                set_osvar efi https://boot.netboot.xyz/ipxe/netboot.xyz-arm64.efi
            else
                set_osvar efi https://boot.netboot.xyz/ipxe/netboot.xyz.efi
            fi
        else
            set_osvar vmlinuz https://boot.netboot.xyz/ipxe/netboot.xyz.lkrn
        fi
    }

    setos_alpine() {
        is_virt && flavour=virt || flavour=lts

        # 不要用https 因为甲骨文云arm initramfs阶段不会从硬件同步时钟，导致访问https出错
        if is_in_china; then
            mirror=http://mirror.nju.edu.cn/alpine/v$releasever
        else
            mirror=http://dl-cdn.alpinelinux.org/alpine/v$releasever
        fi
        set_osvar vmlinuz "$mirror/releases/$basearch/netboot/vmlinuz-$flavour"
        set_osvar initrd "$mirror/releases/$basearch/netboot/initramfs-$flavour"
        set_osvar modloop "$mirror/releases/$basearch/netboot/modloop-$flavour"
        set_osvar repo "$mirror/main"
    }

    setos_debian() {
        is_debian_elts() {
            [ "$releasever" -le 11 ]
        }

        if [ "$releasever" -le 9 ] && [ "$basearch" = aarch64 ]; then
            error_and_exit "Debian $releasever ELTS does not support aarch64."
        fi

        # 用此标记要是否 elts, 用于安装后修改 elts/etls-cn 源
        # shellcheck disable=SC2034
        is_debian_elts && elts=1 || elts=0

        case "$releasever" in
        9) codename=stretch ;;
        10) codename=buster ;;
        11) codename=bullseye ;;
        12) codename=bookworm ;;
        13) codename=trixie ;;
        14) codename=forky ;;
        15) codename=duke ;;
        esac

        if ! is_use_cloud_image && is_debian_elts && is_in_china; then
            warn "
Due to the lack of Debian Freexian ELTS instaler mirrors in China, the installation time may be longer.
Continue?

由于没有 Debian Freexian ELTS 国内安装源，安装时间可能会比较长。
继续安装?
"
            read -r -p '[y/N]: '
            if ! [[ "$REPLY" = [Yy] ]]; then
                exit
            fi
        fi

        # udeb_mirror 安装时的源
        # deb_mirror 安装后要修改成的源
        if is_debian_elts; then
            if is_in_china; then
                # https://github.com/tuna/issues/issues/1999
                # nju 也没同步
                udeb_mirror=deb.freexian.com/extended-lts
                deb_mirror=mirror.nju.edu.cn/debian-elts
                initrd_mirror=mirror.nju.edu.cn/debian-archive/debian
            else
                # 按道理不应该用官方源，但找不到其他源
                udeb_mirror=deb.freexian.com/extended-lts
                deb_mirror=deb.freexian.com/extended-lts
                initrd_mirror=archive.debian.org/debian
            fi
        else
            if is_in_china; then
                # ftp.cn.debian.org 不在国内还严重丢包
                # https://www.itdog.cn/ping/ftp.cn.debian.org
                mirror=mirror.nju.edu.cn/debian
            else
                mirror=deb.debian.org/debian # fastly
            fi
            udeb_mirror=$mirror
            deb_mirror=$mirror
            initrd_mirror=$mirror
        fi

        # 云镜像和 firmware 下载源
        if is_in_china; then
            cdimage_mirror=https://mirror.nju.edu.cn/debian-cdimage
        else
            cdimage_mirror=https://cdimage.debian.org/images # 在瑞典，不是 cdn
            # cloud.debian.org 同样在瑞典，不是 cdn
        fi

        # kernel
        if [ "$no_cloud_kernel" = 1 ]; then
            flavour=
        else
            is_virt && flavour=-cloud || flavour=

            # debian 10 云内核 vultr efi vnc 没有显示
            # 现在改成手动 --no-cloud-kernel 规避
            # [ "$releasever" -le 10 ] && flavour=

            # 甲骨文 arm64 cloud 内核 vnc 没有显示
            [ "$basearch_alt" = arm64 ] && flavour=
        fi

        if is_use_cloud_image; then
            # cloud image
            if [ -z "$img" ]; then
                # https://salsa.debian.org/cloud-team/debian-cloud-images/-/tree/master/config_space/bookworm/files/etc/default/grub.d
                # cloud 包括各种奇怪的优化，例如不显示 grub 菜单
                # 因此使用 nocloud
                if false; then
                    is_virt && ci_type=genericcloud || ci_type=generic
                else
                    ci_type=nocloud
                fi
                img=$cdimage_mirror/cloud/$codename/latest/debian-$releasever-$ci_type-$basearch_alt.qcow2
            fi
            set_osvar img "$img"
        else
            # 传统安装
            initrd_dir=dists/$codename/main/installer-$basearch_alt/current/images/netboot/debian-installer/$basearch_alt

            set_osvar udeb_mirror "$udeb_mirror"
            set_osvar vmlinuz "https://$initrd_mirror/$initrd_dir/linux"
            set_osvar initrd "https://$initrd_mirror/$initrd_dir/initrd.gz"
            set_osvar ks "$confhome/debian.cfg"
            set_osvar firmware "$cdimage_mirror/unofficial/non-free/firmware/$codename/current/firmware.cpio.gz"
            set_osvar codename "$codename"
        fi

        # 官方安装和云镜像都会用到的
        set_osvar deb_mirror "$deb_mirror"
        set_osvar kernel "linux-image$flavour-$basearch_alt"
    }

    setos_kali() {
        if is_use_cloud_image; then
            :
        else
            # 传统安装
            if is_in_china; then
                hostname=mirror.nju.edu.cn
            else
                # http.kali.org (geoip 重定向) 到 kali.download (cf) 或最近的站点
                # 文档还说 which is guaranteed to be up-to-date
                # 但是目测有可能重定义到一个拉黑了部分 IP 的服务器
                # 因此这里用 kali.download (cf)
                # https://www.kali.org/docs/community/kali-linux-mirrors/
                # https://www.kali.org/docs/general-use/kali-apt-sources/
                hostname=kali.download
            fi
            codename=kali-$releasever
            mirror=http://$hostname/kali/dists/$codename/main/installer-$basearch_alt/current/images/netboot/debian-installer/$basearch_alt

            is_virt && flavour=-cloud || flavour=

            set_osvar vmlinuz "$mirror/linux"
            set_osvar initrd "$mirror/initrd.gz"
            set_osvar ks "$confhome/debian.cfg"
            set_osvar deb_mirror "$hostname/kali"
            set_osvar udeb_mirror "$hostname/kali"
            set_osvar codename "$codename"
            set_osvar kernel "linux-image$flavour-$basearch_alt"
            # 缺少 firmware 下载
        fi
    }

    setos_ubuntu() {
        case "$releasever" in
        18.04) codename=bionic ;;
        20.04) codename=focal ;;
        22.04) codename=jammy ;;
        24.04) codename=noble ;;
        26.04) codename=resolute ;;
        esac

        if is_use_cloud_image; then
            # cloud image
            if [ -z "$img" ]; then
                if is_in_china; then
                    # 有的源没有 releases 镜像
                    # https://mirrors.tuna.tsinghua.edu.cn/ubuntu-cloud-images/releases/
                    #   https://unicom.mirrors.ustc.edu.cn/ubuntu-cloud-images/releases/
                    #            https://mirror.nju.edu.cn/ubuntu-cloud-images/releases/

                    ci_mirror=https://mirror.nju.edu.cn/ubuntu-cloud-images
                else
                    ci_mirror=https://cloud-images.ubuntu.com
                fi

                # 以下版本有 minimal 镜像
                # amd64 所有
                # arm64 24.04 和以上
                is_have_minimal_image() {
                    [ "$basearch_alt" = amd64 ] || [ "${releasever%.*}" -ge 24 ]
                }

                basearch_img=$basearch_alt
                if [ "$basearch_alt" = amd64 ] && [ "${releasever%.*}" -ge 26 ] && is_cpu_supports_x86_64_v3; then
                    basearch_img=amd64v3
                fi

                if [ "$minimal" = 1 ]; then
                    if ! is_have_minimal_image; then
                        error_and_exit "Minimal cloud image is not available for $releasever $basearch_alt."
                    fi
                    img=$ci_mirror/minimal/releases/$codename/release/ubuntu-$releasever-minimal-cloudimg-$basearch_img.img
                else
                    # 用 codename 而不是 releasever，可减少一次跳转
                    img=$ci_mirror/releases/$codename/release/ubuntu-$releasever-server-cloudimg-$basearch_img.img
                fi
            fi
            set_osvar img "$img"
        else
            # 传统安装
            if is_in_china; then
                case "$basearch" in
                "x86_64") mirror=https://mirror.nju.edu.cn/ubuntu-releases/$releasever ;;
                "aarch64") mirror=https://mirror.nju.edu.cn/ubuntu-cdimage/releases/$releasever/release ;;
                esac
            else
                case "$basearch" in
                "x86_64") mirror=https://releases.ubuntu.com/$releasever ;;
                "aarch64") mirror=https://cdimage.ubuntu.com/releases/$releasever/release ;;
                esac
            fi

            # iso
            filename=$(curl -L $mirror/ | grep -oP "ubuntu-$releasever.*?-live-server-$basearch_alt.iso" |
                sort -uV | tail -1 | grep .)
            iso=$mirror/$filename
            # 在 ubuntu 20.04 上，file 命令检测 ubuntu 22.04 iso 结果是 DOS/MBR boot sector
            test_url "$iso" iso
            set_osvar iso "$iso"

            # ks
            set_osvar ks "$confhome/deprecated/ubuntu.yaml"
            set_osvar minimal "$minimal"
        fi
    }

    setos_arch() {
        if [ "$basearch" = "x86_64" ]; then
            if is_in_china; then
                mirror=https://mirror.nju.edu.cn/archlinux
            else
                mirror=https://geo.mirror.pkgbuild.com # geoip
            fi
        else
            if is_in_china; then
                mirror=https://mirror.nju.edu.cn/archlinuxarm
            else
                # https 证书有问题
                mirror=http://mirror.archlinuxarm.org # geoip
            fi
        fi

        if is_use_cloud_image; then
            # cloud image
            if [ -z "$img" ]; then
                img=$mirror/images/latest/Arch-Linux-x86_64-cloudimg.qcow2
            fi
            set_osvar img "$img"
        else
            # 传统安装
            case "$basearch" in
            x86_64) dir="core/os/$basearch" ;;
            aarch64) dir="$basearch/core" ;;
            esac
            test_url $mirror/$dir/core.db gzip
            set_osvar mirror "$mirror"
        fi
    }

    setos_nixos() {
        if is_in_china; then
            mirror=https://mirror.nju.edu.cn/nix-channels
        else
            mirror=https://nixos.org/channels
        fi

        if is_use_cloud_image; then
            :
        else
            # 传统安装
            # 该服务器文件缓存 miss 时会响应 206 + Location 头
            # 但 curl 这种情况不会重定向，所以添加 text 类型让它不要报错
            test_url $mirror/nixos-$releasever/store-paths.xz 'xz text'
            set_osvar mirror "$mirror"
        fi
    }

    setos_gentoo() {
        if is_in_china; then
            mirror=https://mirror.nju.edu.cn/gentoo
        else
            mirror=https://distfiles.gentoo.org # cdn77
        fi

        dir=releases/$basearch_alt/autobuilds

        if is_use_cloud_image; then
            if [ -z "$img" ]; then
                # 使用 systemd 且没有 cloud-init
                prefix=di-$basearch_alt-console
                filename=$(curl -L $mirror/$dir/latest-$prefix.txt | grep '.qcow2' | awk '{print $1}' | grep .)
                img=$mirror/$dir/$filename
            fi
            test_url "$img" 'qemu'
        else
            if [ -z "$img" ]; then
                prefix=stage3-$basearch_alt-systemd
                filename=$(curl -L $mirror/$dir/latest-$prefix.txt | grep '.tar.xz' | awk '{print $1}' | grep .)
                img=$mirror/$dir/$filename
                test_url "$img" 'tar.xz'
            fi
        fi
        set_osvar img "$img"
    }

    setos_opensuse() {
        # https://download.opensuse.org/
        # curl 会跳转到最近的镜像源，但可能会被镜像源 block
        # aria2 会跳转使用 metalink

        # https://downloadcontent.opensuse.org    # 德国
        # https://downloadcontentcdn.opensuse.org # fastly cdn

        # 很多国内源缺少 aarch64 tumbleweed appliances
        #                 https://download.opensuse.org/ports/aarch64/tumbleweed/appliances/
        #          https://mirrors.ustc.edu.cn/opensuse/ports/aarch64/tumbleweed/appliances/
        # https://mirrors.tuna.tsinghua.edu.cn/opensuse/ports/aarch64/tumbleweed/appliances/

        if [ -z "$img" ]; then
            if is_in_china; then
                mirror=https://mirror.nju.edu.cn/opensuse
            else
                mirror=https://downloadcontentcdn.opensuse.org
            fi

            if [ "$releasever" = tumbleweed ]; then
                # tumbleweed
                if [ "$basearch" = aarch64 ]; then
                    dir=ports/aarch64/tumbleweed/appliances
                else
                    dir=tumbleweed/appliances
                fi
                file=openSUSE-Tumbleweed-Minimal-VM.$basearch-Cloud.qcow2
            else
                # leap
                dir=distribution/leap/$releasever/appliances
                case "$releasever" in
                16.0) file=Leap-$releasever-Minimal-VM.$basearch-Cloud.qcow2 ;;
                # 16.0) file=Leap-$releasever-Minimal-VM.$basearch-kvm$(if [ "$basearch" = x86_64 ]; then echo '-and-xen'; fi).qcow2 ;;
                esac

                # kvm 镜像里面没有 cloud-init
                # 但不够 Cloud 镜像通用?
                # https://src.opensuse.org/pool/kiwi-templates-Minimal/src/branch/factory/Minimal.kiwi
                # https://build.opensuse.org/projects/Virtualization:Appliances:Images:openSUSE-Tumbleweed/packages/kiwi-templates-Minimal/files/Minimal.kiwi
            fi
            img=$mirror/$dir/$file
        fi
        set_osvar img "$img"
    }

    setos_windows() {
        auto_find_iso=false
        if [ -z "$iso" ]; then
            auto_find_iso=true
            echo "iso url is not set. Attempting to find it automatically."
            find_windows_iso
        fi

        if [[ "$iso" = magnet:* ]]; then
            : # 不测试磁力链接
        else
            local iso_is_tested=false
            local iso_is_direct_link=false
            if $auto_find_iso; then
                # 目前自动获取 iso 肯定不是直连，因此先关闭直连测试
                if false && test_url_grace "$iso" iso 2>/dev/null; then
                    iso_is_tested=true
                    iso_is_direct_link=true
                elif [[ $(echo "$iso" | to_lower) =~ ^https://ntriver.org/drive\?.*\.(iso|img)$ ]]; then
                    info "get direct link"
                    local iso_name=${iso##*\?}
                    local direct_link
                    if direct_link=$(curl -L "https://delivery-api.ntriver.org/generate-link?filename=$iso_name" |
                        grep -oE '"url":"[^"]+"' | cut -d: -f2- | tr -d '"' | grep .); then
                        echo "Direct link: $direct_link" >&2
                        iso="$direct_link"
                        iso_is_direct_link=true
                    else
                        warn false "Failed to get direct link for $iso"
                    fi
                fi

                # 需要用户输入直链的情况
                if ! $iso_is_direct_link; then
                    info "Set Direct link"
                    # MobaXterm 不支持
                    # printf '\e]8;;http://example.com\e\\This is a link\e]8;;\e\\\n'

                    # MobaXterm 不显示为超链接
                    # info false "请在浏览器中打开 $iso 获取直链并粘贴到这里。"
                    # info false "Please open $iso in browser to get the direct link and paste it here."

                    echo "请在浏览器中打开 $iso 获取直链并粘贴到这里。"
                    echo "Please open $iso in browser to get the direct link and paste it here."
                    IFS= read -r -p "Direct Link: " iso
                    if [ -z "$iso" ]; then
                        error_and_exit "ISO Link is empty."
                    elif ! grep -Eiq '^https?://' <<<"$iso"; then
                        error_and_exit "ISO Link is invalid."
                    fi
                fi
            fi

            if ! $iso_is_tested; then
                test_url "$iso" iso
            fi

            # 判断 iso 架构是否兼容
            # https://gitlab.com/libosinfo/osinfo-db/-/tree/main/data/os/microsoft.com?ref_type=heads
            # uupdump linux 下合成的标签是 ARM64，windows下合成的标签是 A64
            if file -b "$tmp/img-test" | grep -Eq '_(A64|ARM64)'; then
                iso_arch=arm64
            else
                iso_arch=x86_or_x64
            fi

            if ! {
                { [ "$basearch" = x86_64 ] && [ "$iso_arch" = x86_or_x64 ]; } ||
                    { [ "$basearch" = aarch64 ] && [ "$iso_arch" = arm64 ]; }
            }; then
                warn "
The current machine is $basearch, but it seems the ISO is for $iso_arch. Continue?
当前机器是 $basearch，但 ISO 似乎是 $iso_arch。继续安装?"
                read -r -p '[y/N]: '
                if ! [[ "$REPLY" = [Yy] ]]; then
                    exit
                fi
            fi
        fi

        [ -n "$boot_wim" ] && test_url "$boot_wim" 'wim'

        set_osvar iso "$iso"
        set_osvar boot_wim "$boot_wim"
        set_osvar image_name "$image_name"
    }

    # shellcheck disable=SC2154
    setos_dd() {
        # raw 包含 vhd
        test_url $img 'raw raw.gzip raw.xz raw.zstd raw.tar.gzip raw.tar.xz raw.tar.zstd' img_type

        if is_efi; then
            install_pkg hexdump

            # openwrt 镜像 efi part type 不是 esp
            # 因此改成检测 fat?
            # https://downloads.openwrt.org/releases/23.05.3/targets/x86/64/openwrt-23.05.3-x86-64-generic-ext4-combined-efi.img.gz

            # od 在 coreutils 里面，好像要配合 tr 才能删除空格
            # hexdump 在 util-linux / bsdmainutils 里面
            # xxd 要单独安装，el 在 vim-common 里面
            # xxd -l $((34 * 4096)) -ps -c 128

            # 仅打印前34个扇区 * 4096字节（按最大的算）
            # 每行128字节
            hexdump -n $((34 * 4096)) -e '128/1 "%02x" "\n"' -v "$tmp/img-test" >$tmp/img-test-hex
            if grep -q '^28732ac11ff8d211ba4b00a0c93ec93b' $tmp/img-test-hex; then
                echo 'DD: Image is EFI.'
            else
                echo 'DD: Image is not EFI.'
                warn '
The current machine uses EFI boot, but the DD image seems not an EFI image.
Continue with DD?
当前机器使用 EFI 引导，但 DD 镜像可能不是 EFI 镜像。
继续 DD?'
                read -r -p '[y/N]: '
                if [[ "$REPLY" = [Yy] ]]; then
                    set_osvar confirmed_no_efi 1
                else
                    exit
                fi
            fi
        fi
        set_osvar img "$img"
        set_osvar img_type "$img_type"
        set_osvar img_type_warp "$img_type_warp"
    }

    setos_fnos() {
        # 系统盘大小
        min=10
        default=64
        echo "请输入系统分区大小，最小 $min GB，但可能无法更新系统。建议 $default GB。"
        echo "Please input System Partition Size. Minimal is $min GB but may not be able to do system updates. Recommended is $default GB."
        while true; do
            IFS= read -r -p "Size in GB [$default]: " input
            input=${input:-$default}
            if ! { is_digit "$input" && [ "$input" -ge "$min" ]; }; then
                error "Invalid Size. Please Try again."
            else
                set_osvar fnos_part_size "${input}G"
                break
            fi
        done

        if [ -z "$iso" ]; then
            local download_page sign_page
            if [ "$FLYGOOS" = 1 ]; then
                download_page=https://fygonas.com/download
                # sign_page=https://fygonas.com/asset/download-sign
            else
                download_page=https://fnnas.com/download$([ "$basearch" = aarch64 ] && echo -arm || true)
                sign_page=https://fnnas.com/asset/download-sign
            fi

            # fnos_Mainland-PE_x86_1.2.0203_2149.iso
            # fnos_Mainland-PE_arm_1.1.31_armsr_1366.iso
            # fygoos_PE_x86_1.2.0203_2150.iso
            # fygoos_PE_arm_1.2.0007_armsr_1837.iso

            # 对于同一行有多个成功匹配，grep -m1 无效
            iso=$(curl -L "$download_page" | grep -o 'https://[^"]*\.iso' |
                grep "$([ "$basearch" = aarch64 ] && echo _armsr_ || echo _x86_)" |
                head -1 | grep .)

            if [ -n "$sign_page" ]; then
                # curl 7.82.0+
                # curl -L --json '{"url":"'$iso'"}' https://fnnas.com/asset/download-sign

                iso=$(curl -L \
                    -d '{"url":"'$iso'"}' \
                    -H 'Content-Type: application/json' \
                    "$sign_page" |
                    grep -o 'https://[^"]*')
            fi
        fi

        test_url "$iso" iso
        set_osvar iso "$iso"
    }

    setos_aosc() {
        if [ -z "$img" ]; then
            if is_in_china; then
                mirror=https://mirror.nju.edu.cn/anthon/aosc-os
            else
                # 服务器在香港
                mirror=https://releases.aosc.io
            fi

            dir=os-$basearch_alt/base
            file=$(curl -L $mirror/$dir/ | grep -oP 'aosc-os_base_.*?\.tar.xz' |
                sort -uV | tail -1 | grep .)
            img=$mirror/$dir/$file
        fi
        test_url "$img" 'tar.xz'
        set_osvar img "$img"
    }

    setos_centos_almalinux_rocky_fedora() {
        # el 10 需要 x86-64-v3，除了 almalinux
        if [ "$basearch" = x86_64 ] &&
            { [ "$distro" = centos ] || [ "$distro" = rocky ]; } &&
            [ "$releasever" -ge 10 ]; then
            assert_cpu_supports_x86_64_v3
        fi

        elarch=$basearch
        if [ "$basearch" = x86_64 ] &&
            [ "$distro" = almalinux ] && [ "$releasever" -ge 10 ] &&
            ! is_cpu_supports_x86_64_v3; then
            elarch=x86_64_v2
        fi

        if is_use_cloud_image; then
            # ci
            if [ -z "$img" ]; then
                if is_in_china; then
                    case $distro in
                    centos) ci_mirror="https://mirror.nju.edu.cn/centos-cloud/centos" ;;
                    almalinux) ci_mirror="https://mirror.nju.edu.cn/almalinux/$releasever/cloud/$elarch/images" ;;
                    rocky) ci_mirror="https://mirror.nju.edu.cn/rocky/$releasever/images/$elarch" ;;
                    fedora) ci_mirror="https://mirror.nju.edu.cn/fedora/releases/$releasever/Cloud/$elarch/images" ;;
                    esac
                else
                    case $distro in
                    centos) ci_mirror="https://cloud.centos.org/centos" ;;
                    almalinux) ci_mirror="https://repo.almalinux.org/almalinux/$releasever/cloud/$elarch/images" ;;
                    rocky) ci_mirror="https://download.rockylinux.org/pub/rocky/$releasever/images/$elarch" ;;
                    fedora) ci_mirror="https://d2lzkl7pfhq30w.cloudfront.net/pub/fedora/linux/releases/$releasever/Cloud/$elarch/images" ;;
                    esac
                fi
                case $distro in
                centos)
                    case $releasever in
                    7)
                        # CentOS-7-aarch64-GenericCloud.qcow2c 是旧版本
                        ver=-2211
                        img=$ci_mirror/$releasever/images/CentOS-$releasever-$elarch-GenericCloud$ver.qcow2c
                        ;;
                    *)
                        # 有 bios 和 efi 镜像
                        # https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2
                        # https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-x86_64-10-latest.x86_64.qcow2
                        [ "$elarch" = x86_64 ] &&
                            img=$ci_mirror/$releasever-stream/$elarch/images/CentOS-Stream-GenericCloud-x86_64-$releasever-latest.$elarch.qcow2 ||
                            img=$ci_mirror/$releasever-stream/$elarch/images/CentOS-Stream-GenericCloud-$releasever-latest.$elarch.qcow2
                        ;;
                    esac
                    ;;
                almalinux) img=$ci_mirror/AlmaLinux-$releasever-GenericCloud-latest.$elarch.qcow2 ;;
                rocky) img=$ci_mirror/Rocky-$releasever-GenericCloud-Base.latest.$elarch.qcow2 ;;
                fedora)
                    # 不加 / 会跳转到 https://dl.fedoraproject.org，纯 ipv6 无法访问
                    # curl -L -6 https://d2lzkl7pfhq30w.cloudfront.net/pub/fedora/linux/releases/42/Cloud/x86_64/images
                    # curl -L -6 https://d2lzkl7pfhq30w.cloudfront.net/pub/fedora/linux/releases/42/Cloud/x86_64/images/
                    filename=$(curl -L $ci_mirror/ | grep -oP "Fedora-Cloud-Base-Generic.*?.qcow2" |
                        sort -uV | tail -1 | grep .)
                    img=$ci_mirror/$filename
                    ;;
                esac
            fi
            set_osvar img "$img"
        else
            # 传统安装
            case $distro in
            centos) mirrorlist="https://mirrors.centos.org/mirrorlist?repo=centos-baseos-$releasever-stream&arch=$elarch" ;;
            almalinux) mirrorlist="https://mirrors.almalinux.org/mirrorlist/$releasever/baseos" ;;
            rocky) mirrorlist="https://mirrors.rockylinux.org/mirrorlist?arch=$elarch&repo=BaseOS-$releasever" ;;
            fedora) mirrorlist="https://mirrors.fedoraproject.org/mirrorlist?arch=$elarch&repo=fedora-$releasever" ;;
            esac

            # rocky/centos9 需要删除第一行注释， almalinux 需要替换链接里面的 $basearch
            for cur_mirror in $(curl -L $mirrorlist | sed "/^#/d" | sed "s,\$basearch,$elarch,"); do
                host=$(get_host_by_url $cur_mirror)
                if is_host_has_ipv4_and_ipv6 $host &&
                    test_url_grace ${cur_mirror}images/pxeboot/vmlinuz; then
                    mirror=$cur_mirror
                    break
                fi
            done

            if [ -z "$mirror" ]; then
                error_and_exit "All mirror failed."
            fi

            set_osvar mirrorlist "$mirrorlist"

            set_osvar ks "$confhome/deprecated/redhat.cfg"
            set_osvar vmlinuz "${mirror}images/pxeboot/vmlinuz"
            set_osvar initrd "${mirror}images/pxeboot/initrd.img"
            set_osvar squashfs "${mirror}images/install.img"
            test_url ${mirror}images/install.img 'squashfs'
        fi
    }

    setos_oracle() {
        # el 10 需要 x86-64-v3
        if [ "$basearch" = x86_64 ] && [ "$releasever" -ge 10 ]; then
            assert_cpu_supports_x86_64_v3
        fi

        if is_use_cloud_image; then
            # ci
            if [ -z "$img" ]; then
                install_pkg jq
                mirror=https://yum.oracle.com

                [ "$basearch" = aarch64 ] &&
                    template_prefix=ol${releasever}_${basearch}-cloud ||
                    template_prefix=ol${releasever}
                curl -Lo $tmp/oracle.json $mirror/templates/OracleLinux/$template_prefix-template.json
                dir=$(jq -r .base_url $tmp/oracle.json)
                file=$(jq -r .kvm.image $tmp/oracle.json)
                img=$mirror$dir/$file
            fi
            set_osvar img "$img"
        else
            :
        fi
    }

    setos_redhat() {
        if is_use_cloud_image; then
            # el 10 需要 x86-64-v3
            if [ "$basearch" = x86_64 ] && [[ "$img" = *rhel-10* ]]; then
                assert_cpu_supports_x86_64_v3
            fi
            set_osvar img "$img"
        else
            :
        fi
    }

    setos_opencloudos() {
        # https://mirrors.opencloudos.tech 不支持 ipv6

        # mirrors.cloud.tencent.com 为公网与内网统一域名
        # https://cloud.tencent.com/document/product/213/8623
        if [ "$releasever" -ge 23 ]; then
            mirror=https://mirrors.cloud.tencent.com/opencloudos-stream/releases
        else
            mirror=https://mirrors.cloud.tencent.com/opencloudos
        fi

        if is_use_cloud_image; then
            # ci
            # https://opencloudos.org/api/v1/iso-releases/published
            if [ -z "$img" ]; then
                if [ "$releasever" -eq 9 ]; then
                    dir=$releasever/images/qcow2/$basearch
                else
                    dir=$releasever/images/$basearch
                fi

                file=$(curl -L $mirror/$dir/ | grep -oP 'OpenCloudOS.*?\.qcow2' |
                    sort -uV | tail -1 | grep .)
                img=$mirror/$dir/$file
            fi
            set_osvar img "$img"
        else
            :
        fi
    }

    setos_anolis() {
        mirror=https://mirrors.openanolis.cn/anolis
        if is_use_cloud_image; then
            # ci
            if [ -z "$img" ]; then
                dir=$releasever/isos/GA/$basearch
                [ "$releasever" -ge 23 ] &&
                    filename='AnolisOS.*?\.qcow2' ||
                    filename='AnolisOS.*?-ANCK\.qcow2'
                file=$(curl -L $mirror/$dir/ | grep -oP "$filename" |
                    sort -uV | tail -1 | grep .)
                img=$mirror/$dir/$file
            fi
            set_osvar img "$img"
        else
            :
        fi
    }

    setos_openeuler() {
        if is_in_china; then
            mirror=https://repo.openeuler.openatom.cn
        else
            mirror=https://repo.openeuler.org
        fi
        if is_use_cloud_image; then
            # ci
            if [ -z "$img" ]; then
                name=$(curl -L "$mirror/" | grep -oE "openEuler-$releasever(-LTS)?(-SP[0-9])?" |
                    sort -uV | tail -1 | grep .)
                img=$mirror/$name/virtual_machine_img/$basearch/$name-$basearch.qcow2.xz
            fi
            set_osvar img "$img"
        else
            :
        fi
    }

    set_osvar distro "$distro"
    set_osvar releasever "$releasever"

    case "$distro" in
    centos | almalinux | rocky | fedora) setos_centos_almalinux_rocky_fedora ;;
    *) setos_$distro ;;
    esac

    # debian/kali <=256M 必须使用云内核，否则不够内存
    if is_distro_like_debian && ! is_in_windows && [ "$ram_size" -le 256 ]; then
        exit_if_cant_use_cloud_kernel
    fi

    # 集中测试云镜像格式
    if is_use_cloud_image && [ "$step" = finalos ]; then
        # shellcheck disable=SC2154
        test_url $finalos_img 'qemu qemu.gzip qemu.xz qemu.zstd raw.xz' finalos_img_type
    fi
}

is_distro_like_redhat() {
    if [ -n "$1" ]; then
        _distro=$1
    else
        _distro=$distro
    fi
    [ "$_distro" = redhat ] || [ "$_distro" = centos ] || [ "$_distro" = almalinux ] || [ "$_distro" = rocky ] || [ "$_distro" = fedora ] || [ "$_distro" = oracle ]
}

is_distro_like_debian() {
    if [ -n "$1" ]; then
        _distro=$1
    else
        _distro=$distro
    fi
    [ "$_distro" = debian ] || [ "$_distro" = kali ]
}

get_latest_distro_releasever() {
    get_function_content verify_os_name |
        grep -wo "$1 [^'\"]*" | awk -F'|' '{print $NF}'
}

# 检查是否为正确的系统名
verify_os_name() {
    if [ -z "$*" ]; then
        usage_and_exit
    fi

    # 不要删除 centos 7
    for os in \
        'centos      7|9|10' \
        'anolis      7|8|23' \
        'opencloudos 8|9|23' \
        'almalinux   8|9|10' \
        'rocky       8|9|10' \
        'oracle      8|9|10' \
        'fnos        1' \
        'fygoos      1' \
        'fedora      43|44' \
        'nixos       26.05' \
        'debian      9|10|11|12|13' \
        'opensuse    16.0|tumbleweed' \
        'alpine      3.21|3.22|3.23|3.24' \
        'openeuler   20.03|22.03|24.03' \
        'ubuntu      18.04|20.04|22.04|24.04|26.04' \
        'kali        last-snapshot|rolling' \
        'redhat' \
        'arch' \
        'gentoo' \
        'aosc' \
        'windows' \
        'dd' \
        'netboot.xyz' \
        'reset'; do
        read -r ds vers <<<"$os"
        vers_=${vers//\./\\\.}
        finalos=$(echo "$@" | to_lower | sed -n -E "s,^($ds)[ :-]?(|$vers_)$,\1 \2,p")
        if [ -n "$finalos" ]; then
            read -r distro releasever <<<"$finalos"
            # fygoos to fnos
            if [ "$distro" = fygoos ]; then
                distro=fnos
                FLYGOOS=1
            fi
            # 默认版本号
            if [ -z "$releasever" ] && [ -n "$vers" ]; then
                releasever=$(awk -F '|' '{print $NF}' <<<"|$vers")
            fi
            return
        fi
    done

    error "Please specify a proper os"
    usage_and_exit
}

verify_os_args() {
    # 必备参数
    case "$distro" in
    dd) [ -n "$img" ] || error_and_exit "dd need --img." ;;
    redhat) [ -n "$img" ] || error_and_exit "redhat need --img." ;;
    windows) [ -n "$image_name" ] || error_and_exit "Install Windows need --image-name." ;;
    esac

    # 用户名/密码/证书相关
    case "$distro" in
    netboot.xyz)
        [ -z "$username" ] || error_and_exit "not support set username for $distro."
        [ -z "$password" ] || error_and_exit "not support set password for $distro."
        [ -z "$ssh_keys" ] || error_and_exit "not support set ssh key for $distro."
        ;;
    windows)
        [ -z "$ssh_keys" ] || error_and_exit "not support set ssh key for $distro."
        ;;
    esac

    # 不能同时使用证书和密码
    if [ -n "$password" ] && [ -n "$ssh_keys" ]; then
        error_and_exit "Cannot set both password and ssh key."
    fi
}

get_cmd_path() {
    # arch 云镜像不带 which
    # command -v 包括脚本里面的方法
    # ash 无效
    type -f -p $1
}

is_have_cmd() {
    get_cmd_path $1 >/dev/null 2>&1
}

install_pkg() {
    is_in_windows && return

    find_pkg_mgr() {
        [ -n "$pkg_mgr" ] && return

        # 查找方法1: 通过 ID / ID_LIKE
        # 因为可能装了多种包管理器
        if [ -f /etc/os-release ]; then
            # shellcheck source=/dev/null
            for id in $({ . /etc/os-release && echo $ID $ID_LIKE; }); do
                # https://github.com/chef/os_release
                case "$id" in
                fedora | centos | rhel) is_have_cmd dnf && pkg_mgr=dnf || pkg_mgr=yum ;;
                debian | ubuntu) pkg_mgr=apt-get ;;
                opensuse | suse) pkg_mgr=zypper ;;
                alpine) pkg_mgr=apk ;;
                arch) pkg_mgr=pacman ;;
                gentoo) pkg_mgr=emerge ;;
                nixos) pkg_mgr=nix-env ;;
                esac
                [ -n "$pkg_mgr" ] && return
            done
        fi

        # 查找方法 2
        for mgr in dnf yum apt-get pacman zypper emerge apk nix-env; do
            is_have_cmd $mgr && pkg_mgr=$mgr && return
        done

        return 1
    }

    cmd_to_pkg() {
        unset USE
        case $cmd in
        ar)
            case "$pkg_mgr" in
            *) pkg="binutils" ;;
            esac
            ;;
        xz)
            case "$pkg_mgr" in
            apt-get) pkg="xz-utils" ;;
            *) pkg="xz" ;;
            esac
            ;;
        lsblk | findmnt)
            case "$pkg_mgr" in
            apk) pkg="$cmd" ;;
            *) pkg="util-linux" ;;
            esac
            ;;
        lsmem)
            case "$pkg_mgr" in
            apk) pkg="util-linux-misc" ;;
            *) pkg="util-linux" ;;
            esac
            ;;
        fdisk)
            case "$pkg_mgr" in
            apt-get) pkg="fdisk" ;;
            apk) pkg="util-linux-misc" ;;
            *) pkg="util-linux" ;;
            esac
            ;;
        hexdump)
            case "$pkg_mgr" in
            apt-get) pkg="bsdmainutils" ;;
            *) pkg="util-linux" ;;
            esac
            ;;
        unsquashfs)
            case "$pkg_mgr" in
            zypper) pkg="squashfs" ;;
            emerge) pkg="squashfs-tools" && export USE="lzma" ;;
            *) pkg="squashfs-tools" ;;
            esac
            ;;
        nslookup | dig)
            case "$pkg_mgr" in
            apt-get) pkg="dnsutils" ;;
            pacman) pkg="bind" ;;
            apk | emerge) pkg="bind-tools" ;;
            yum | dnf | zypper) pkg="bind-utils" ;;
            esac
            ;;
        iconv)
            case "$pkg_mgr" in
            apk) pkg="musl-utils" ;;
            *) error_and_exit "Which GNU/Linux do not have iconv built-in?" ;;
            esac
            ;;
        *) pkg=$cmd ;;
        esac
    }

    # 系统                       package名称                                    repo名称
    # centos/alma/rocky/fedora   epel-release                                   epel
    # oracle linux               oracle-epel-release                            ol9_developer_EPEL
    # opencloudos                epol-release                                   EPOL
    # alibaba cloud linux 3      epel-release/epel-aliyuncs-release(qcow2自带)  epel
    # anolis 23                  anolis-epao-release                            EPAO

    # anolis 8
    # [root@localhost ~]# yum search *ep*-release | grep -v next
    # ========================== Name Matched: *ep*-release ==========================
    # anolis-epao-release.noarch : EPAO Packages for Anolis OS 8 repository configuration
    # epel-aliyuncs-release.noarch : Extra Packages for Enterprise Linux repository configuration
    # epel-release.noarch : Extra Packages for Enterprise Linux repository configuration (qcow2自带)

    check_is_need_epel() {
        is_need_epel() {
            case "$pkg" in
            dpkg) true ;;
            jq) is_have_cmd yum && ! is_have_cmd dnf ;; # el7/ol7 的 jq 在 epel 仓库
            *) false ;;
            esac
        }

        get_epel_repo_name() {
            # el7 不支持 yum repolist --all，要使用 yum repolist all
            # el7 yum repolist 第一栏有 /x86_64 后缀，因此要去掉。而 el9 没有
            $pkg_mgr repolist all | awk '{print $1}' | awk -F/ '{print $1}' | grep -Ei 'ep(el|ol|ao)$'
        }

        get_epel_pkg_name() {
            # el7 不支持 yum list --available，要使用 yum list available
            $pkg_mgr list available | grep -E '(.*-)?ep(el|ol|ao)-(.*-)?release' |
                awk '{print $1}' | cut -d. -f1 | grep -v next | head -1
        }

        if is_need_epel; then
            if ! epel=$(get_epel_repo_name); then
                $pkg_mgr install -y "$(get_epel_pkg_name)"
                epel=$(get_epel_repo_name)
            fi
            enable_epel="--enablerepo=$epel"
        else
            enable_epel=
        fi
    }

    install_pkg_real() {
        text="$pkg"
        if [ "$pkg" != "$cmd" ]; then
            text+=" ($cmd)"
        fi
        echo "Installing package '$text'..."

        case $pkg_mgr in
        dnf)
            check_is_need_epel
            dnf install $enable_epel -y --setopt=install_weak_deps=False $pkg
            ;;
        yum)
            check_is_need_epel
            yum install $enable_epel -y $pkg
            ;;
        emerge) emerge --oneshot $pkg ;;
        pacman) pacman -Syu --noconfirm --needed $pkg ;;
        zypper) zypper install -y $pkg ;;
        apk)
            add_community_repo_for_alpine
            apk add $pkg
            ;;
        apt-get)
            [ -z "$apt_updated" ] && apt-get update && apt_updated=1
            DEBIAN_FRONTEND=noninteractive apt-get install -y $pkg
            ;;
        nix-env)
            # 不指定 channel 会很慢，而且很占内存
            [ -z "$nix_updated" ] && nix-channel --update && nix_updated=1
            nix-env -iA nixos.$pkg
            ;;
        esac
    }

    is_need_reinstall() {
        local cmd=$1

        # gentoo 默认编译的 unsquashfs 不支持 xz
        if [ "$cmd" = unsquashfs ] && is_have_cmd emerge && ! "$cmd" |& grep -wq xz; then
            echo "unsquashfs not supported xz. rebuilding."
            return 0
        fi

        # busybox grep  不支持 -oP
        # busybox lsblk 不支持 -r -n --inverse
        # busybox fdisk 无法显示 mbr 分区表的 id
        if { [ "$cmd" = grep ] || [ "$cmd" = lsblk ] || [ "$cmd" = fdisk ]; } &&
            is_have_cmd apk && "$cmd" --help |& grep -wq BusyBox; then
            return 0
        fi

        return 1
    }

    for cmd in "$@"; do
        if ! is_have_cmd $cmd || is_need_reinstall $cmd; then
            if ! find_pkg_mgr; then
                error_and_exit "Can't find compatible package manager. Please manually install $cmd."
            fi
            cmd_to_pkg
            install_pkg_real
        fi
    done >&2
}

is_valid_ram_size() {
    is_digit "$1" && [ "$1" -gt 0 ]
}

check_ram() {
    ram_standard=$(
        case "$distro" in
        netboot.xyz) echo 0 ;;
        alpine | debian | kali | dd) echo 256 ;;
        arch | gentoo | aosc | nixos | windows) echo 512 ;;
        redhat | centos | almalinux | rocky | fedora | oracle | ubuntu | anolis | opencloudos | openeuler) echo 1024 ;;
        opensuse | fnos) echo -1 ;; # 没有安装模式
        esac
    )

    # 不用检查内存的情况
    if [ "$ram_standard" -eq 0 ]; then
        return
    fi

    # 未测试
    ram_cloud_image=256

    has_cloud_image=$(
        case "$distro" in
        redhat | centos | almalinux | rocky | oracle | fedora | debian | ubuntu | opensuse | anolis | openeuler) echo true ;;
        netboot.xyz | alpine | dd | arch | gentoo | nixos | kali | windows) echo false ;;
        esac
    )

    if is_in_windows; then
        ram_size=$(wmic memorychip get capacity | awk -F= '{sum+=$2} END {if(sum>0) print sum/1024/1024}')
    else
        # lsmem最准确但 centos7 arm 和 alpine 不能用，debian 9 util-linux 没有 lsmem
        # arm 24g dmidecode 显示少了128m
        # arm 24g lshw 显示23BiB
        # ec2 t4g arm alpine 用 lsmem 和 dmidecode 都无效，要用 lshw，但结果和free -m一致，其他平台则没问题
        install_pkg lsmem
        ram_size=$(lsmem -b 2>/dev/null | grep 'Total online memory:' | awk '{ print $NF/1024/1024 }')

        if ! is_valid_ram_size "$ram_size"; then
            install_pkg dmidecode
            ram_size=$(dmidecode -t 17 | grep "Size.*[GM]B" | awk '{if ($3=="GB") s+=$2*1024; else s+=$2} END {if(s>0) print s}')
        fi

        if ! is_valid_ram_size "$ram_size"; then
            install_pkg lshw
            # 不能忽略 -i，alpine 显示的是 System memory
            ram_str=$(lshw -c memory -short | grep -i 'System Memory' | awk '{print $3}')
            ram_size=$(grep <<<$ram_str -o '[0-9]*')
            grep <<<$ram_str GiB && ram_size=$((ram_size * 1024))
        fi
    fi

    # 用于兜底，不太准确
    # cygwin 要装 procps-ng 才有 free 命令
    if ! is_valid_ram_size "$ram_size"; then
        ram_size_k=$(grep '^MemTotal:' /proc/meminfo | awk '{print $2}')
        ram_size=$((ram_size_k / 1024 + 64 + 4))
    fi

    if ! is_valid_ram_size "$ram_size"; then
        error_and_exit "Could not detect RAM size."
    fi

    # ram 足够就用普通方法安装，否则如果内存大于512就用 cloud image
    # TODO: 测试 256 384 内存
    if ! is_use_cloud_image && [ $ram_size -lt $ram_standard ]; then
        if $has_cloud_image; then
            info "RAM < $ram_standard MB. Fallback to cloud image mode"
            cloud_image=1
        else
            error_and_exit "Could not install $distro: RAM < $ram_standard MB."
        fi
    fi

    if is_use_cloud_image && [ $ram_size -lt $ram_cloud_image ]; then
        error_and_exit "Could not install $distro using cloud image: RAM < $ram_cloud_image MB."
    fi
}

is_efi() {
    if is_in_windows; then
        # bcdedit | grep -qi '^path.*\.efi'
        mountvol | grep -q -a 'EFI'
    else
        [ -d /sys/firmware/efi ]
    fi
}

is_grub_dir_linked() {
    # cloudcone 重装前/重装后(方法1)
    [ "$(readlink -f /boot/grub/grub.cfg)" = /boot/grub2/grub.cfg ] ||
        [ "$(readlink -f /boot/grub2/grub.cfg)" = /boot/grub/grub.cfg ] ||
        # cloudcone 重装后(方法2)
        { [ -f /boot/grub2/grub.cfg ] && [ "$(cat /boot/grub2/grub.cfg)" = 'chainloader (hd0)+1' ]; }
}

is_secure_boot_enabled() {
    if is_efi; then
        if is_in_windows; then
            reg query 'HKLM\SYSTEM\CurrentControlSet\Control\SecureBoot\State' /v UEFISecureBootEnabled 2>/dev/null | grep 0x1
        else
            if dmesg | grep -i 'Secure boot enabled'; then
                return 0
            fi
            install_pkg mokutil
            mokutil --sb-state 2>&1 | grep -i 'SecureBoot enabled'
        fi
    else
        return 1
    fi
}

is_need_boot_vmlinuz() {
    ! { is_netboot_xyz && is_efi; }
}

# 只有 linux bios 是用本机的 grub/extlinux
is_use_local_grub_extlinux() {
    is_need_boot_vmlinuz && ! is_in_windows && ! is_efi
}

is_use_local_grub() {
    is_use_local_grub_extlinux && is_mbr_using_grub
}

is_use_local_extlinux() {
    is_use_local_grub_extlinux && ! is_mbr_using_grub
}

# 软 raid 时 xda 可能不是引导盘，以后再修正
is_mbr_using_grub() {
    find_main_disk
    # 各发行版不一定自带 strings hexdump xxd od 命令
    head -c 440 /dev/$xda | grep -a -iq 'GRUB'
}

to_upper() {
    tr '[:lower:]' '[:upper:]'
}

to_lower() {
    tr '[:upper:]' '[:lower:]'
}

del_cr() {
    # wmic/reg 换行符是 \r\r\n
    # wmic nicconfig where InterfaceIndex=$id get MACAddress,IPAddress,IPSubnet,DefaultIPGateway | hexdump -c
    sed -E 's/\r+$//'
}

del_empty_lines() {
    sed '/^[[:space:]]*$/d'
}

del_comment_lines() {
    sed '/^[[:space:]]*#/d'
}

trim() {
    # sed -E -e 's/^[[:space:]]+//' -e 's/[[:space:]]+$//'
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

assert_username_valid() {
    # https://learn.microsoft.com/windows-hardware/customize/desktop/unattend/microsoft-windows-shell-setup-useraccounts-localaccounts-localaccount-name
    # 不能为 none [ ] / \ : | < > + = ; , ? * % @

    # 账号为空
    if [ -z "$username" ]; then
        error_and_exit "Username: Can not be empty."
    fi

    # 账号为 none
    if [ "$(to_lower <<<"$username")" = none ]; then
        error_and_exit "Username: Can not be 'none'."
    fi

    # 账号包含非法字符
    if grep -q '[][/\:|<>+=;,?*%@]' <<<"$username"; then
        error_and_exit "Username: Do not use any of the following characters: / \ [ ] : | < > + = ; , ? * % @"
    fi
}

# trans.sh 有同名方法
is_administrator_username() {
    username_in_lower=$(to_lower <<<"$1")

    # 如果输入以下用户名则忽略，并使用系统内置的 Administrator 账号
    # 防止系统有两个不同语言的 Administrator 账号而造成困扰
    for builtin_username in \
        administrator \
        administrador \
        administrateur \
        administratör \
        администратор \
        järjestelmänvalvoja \
        rendszergazda; do
        if [ "$username_in_lower" = "$builtin_username" ]; then
            return 0
        fi
    done

    return 1
}

prompt_username() {
    info "prompt username"

    if [ "$distro" = windows ]; then
        default_username=administrator
    else
        default_username=root
    fi

    warn false "Set username, leave blank to use $default_username"
    warn false "设置用户名，不填写则使用 $default_username"
    IFS= read -r -p "Username: " username
    username="$(printf "%s" "$username" | trim)"

    if [ -z "$username" ]; then
        username=$default_username
    fi
    assert_username_valid
}

prompt_password() {
    info "prompt password"
    warn false "Set password, leave blank to use a random password."
    warn false "设置密码，不填写则使用随机密码"
    while true; do
        IFS= read -r -p "Password: " password
        if [ -n "$password" ]; then
            IFS= read -r -p "Retype password: " password_confirm
            if [ "$password" = "$password_confirm" ]; then
                break
            else
                error "Passwords don't match. Try again."
            fi
        else
            # 特殊字符列表
            # https://learn.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/hh994562(v=ws.11)
            # 有的机器运行 centos 7 ，用 /dev/random 产生 16 位密码，开启了 rngd 也要 5 秒，关闭了 rngd 则长期阻塞
            chars=\''A-Za-z0-9~!@#$%^&*_=+`|(){}[]:;"<>,.?/-'
            password=$(tr -dc "$chars" </dev/urandom | head -c16)
            break
        fi
    done
}

save_password() {
    dir=$1

    # mkpasswd 有三个
    # expect 里的 mkpasswd 是用来生成随机密码的
    # whois 里的 mkpasswd 才是我们想要的，可能不支持 yescrypt，alpine 的 mkpasswd 是独立的包
    # busybox 里的 mkpasswd 也是我们想要的，但多数不支持 yescrypt

    # alpine 这两个包有冲突
    # apk add expect mkpasswd

    # 不要用 echo "$password" 保存密码，原因：
    # password="-n"
    # echo "$password"  # 空白

    # 明文密码
    # 假如用户运行 alpine live 直接打包硬盘镜像，如果保存了明文密码，则会暴露明文密码，因为 netboot initrd 在里面
    # 通过 --password 传入密码，history 有记录，也会暴露明文密码
    # /reinstall.log 也会暴露明文密码（已处理）
    if false; then
        printf '%s' "$password" >>"$dir/password-plaintext"
    fi

    # sha512
    # 以下系统均支持 sha512 密码，但是生成密码需要不同的工具
    # 兼容性     openssl   mkpasswd          busybox  python
    # centos 7     ×      只有expect的       需要编译    √
    # centos 8     √      只有expect的
    # debian 9     ×         √
    # ubuntu 16    ×         √
    # alpine       √      可能系统装了expect     √
    # cygwin       √
    # others       √

    # alpine
    if is_have_cmd busybox && busybox mkpasswd --help 2>&1 | grep -wq sha512; then
        crypted=$(printf '%s' "$password" | busybox mkpasswd -m sha512)
    # others
    elif install_pkg openssl && openssl passwd --help 2>&1 | grep -wq '\-6'; then
        crypted=$(printf '%s' "$password" | openssl passwd -6 -stdin)
    # debian 9 / ubuntu 16
    elif is_have_cmd apt-get && install_pkg whois && mkpasswd -m help | grep -wq sha-512; then
        crypted=$(printf '%s' "$password" | mkpasswd -m sha-512 --stdin)
    # centos 7
    # crypt.mksalt 是 python3 的
    # 红帽把它 backport 到了 centos7 的 python2 上
    # 在其它发行版的 python2 上运行会出错
    elif is_have_cmd yum && is_have_cmd python2; then
        crypted=$(python2 -c "import crypt, sys; print(crypt.crypt(sys.argv[1], crypt.mksalt(crypt.METHOD_SHA512)))" "$password")
    else
        error_and_exit "Could not generate sha512 password."
    fi
    echo "$crypted" >"$dir/password-linux-sha512"

    # yescrypt
    # 旧系统不支持，先不管
    if false; then
        if mkpasswd -m help | grep -wq yescrypt; then
            crypted=$(printf '%s' "$password" | mkpasswd -m yescrypt --stdin)
            echo "$crypted" >"$dir/password-linux-yescrypt"
        fi
    fi

    # windows
    if [ "$distro" = windows ]; then
        install_pkg iconv

        # 要分两行写，因为 echo "$(xxx)" 返回值始终为 0，出错也不会中断脚本
        # grep . 为了保证脚本没有出错
        base64=$(printf '%s' "${password}Password" | iconv -f UTF-8 -t UTF-16LE | base64 -w 0 | grep .)
        echo "$base64" >"$dir/password-windows-user-base64"

        base64=$(printf '%s' "${password}AdministratorPassword" | iconv -f UTF-8 -t UTF-16LE | base64 -w 0 | grep .)
        echo "$base64" >"$dir/password-windows-administrator-base64"
    fi
}

# 记录主硬盘
find_main_disk() {
    if [ -n "$main_disk" ]; then
        return
    fi

    if is_in_windows; then
        # TODO:
        # 已测试 vista
        # 测试 软raid
        # 测试 动态磁盘

        # diskpart 命令结果
        # 磁盘 ID: E5FDE61C
        # 磁盘 ID: {92CF6564-9B2E-4348-A3BD-D84E3507EBD7}
        main_disk=$(printf "%s\n%s" "select volume $c" "uniqueid disk" | diskpart |
            tail -1 | awk '{print $NF}' | sed 's,[{}],,g')
    else
        if [ -z "$xda" ]; then
            # centos7下测试     lsblk --inverse $mapper | grep -w disk     grub2-probe -t disk /
            # 跨硬盘btrfs       只显示第一个硬盘                            显示两个硬盘
            # 跨硬盘lvm         显示两个硬盘                                显示/dev/mapper/centos-root
            # 跨硬盘软raid      显示两个硬盘                                显示/dev/md127

            # 还有 findmnt

            # 理论上 /boot/efi /efi /boot 可以不在主硬盘上
            # 因此只查找 / 分区

            install_pkg lsblk
            # lvm 显示的是 /dev/mapper/xxx-yyy，再用第二条命令得到sda
            mapper=$(mount | awk '$3=="/" {print $1}' | grep .)
            xdas=$(lsblk -rn --inverse $mapper | grep -w disk | awk '{print $1}' | sort -u | grep .)

            # 注意 wc -l 的坑
            # wc -l <<<"" 输出 1

            # 检测主硬盘是否横跨多个磁盘
            if [ "$(wc -l <<<"$xdas")" -eq 1 ]; then
                xda=$xdas
            else
                # vultr 官网新建数据盘时有写，部分地区的实例，不能从数据盘启动
                # 实测 nvram 可写入数据盘的条目但不生效，手动安装 debian 到此硬盘，nvram 也不生效
                # 从 bios 手动选择数据盘的 efi 文件才能启动
                # 但是 nvram BootNext 数据盘的条目却可以生效

                # vultr 从软 raid 0 debian 下用本脚本安装 debian ，进入 grub efi 时，无法识别系统分区 md1 的文件系统，也少了 hd1
                # 但是从 bios 手动选择 reinstall 的 grub efi 时却可以识别
                # 后期应该将 vmlinux/initrd 放到 efi/boot 分区

                # Gemini 说:
                # 使用 efibootmgr 的 BootNext 时，固件走的是“快速路径”：
                # 它只初始化存放 EFI 引导文件（grubx64.efi）的那块硬盘（hd0），然后直接把控制权交给 GRUB。
                # 因为 hd1 还没“醒”，GRUB 自然无法拼凑出完整的 md1 阵列，导致无法识别文件系统。

                # 使用 nativedisk 可以强制 grub 识别所有硬盘?
                info false "Multiple disks found for root partition:"
                echo '-----'
                printf "%s\n" "$xdas"
                echo '-----'
                read -r -p "Select a disk to install: " xda
                if ! grep -Fqx "$xda" <<<"$xdas"; then
                    error_and_exit "Invalid Input."
                fi
            fi
        fi

        info "Main disk: $xda"

        # 可以用 dd 找出 guid?

        # centos7 blkid lsblk 不显示 PTUUID
        # centos7 sfdisk 不显示 Disk identifier
        # alpine blkid 不显示 gpt 分区表的 PTUUID
        # 因此用 fdisk

        # Disk identifier: 0x36778223                                  # gnu fdisk + mbr
        # Disk identifier: D6B17C1A-FA1E-40A1-BDCB-0278A3ED9CFC        # gnu fdisk + gpt
        # Disk identifier (GUID): d6b17c1a-fa1e-40a1-bdcb-0278a3ed9cfc # busybox fdisk + gpt
        # 不显示 Disk identifier                                        # busybox fdisk + mbr

        # 获取 xda 的 id
        install_pkg fdisk
        main_disk=$(fdisk -l /dev/$xda | grep 'Disk identifier' | awk '{print $NF}' | sed 's/0x//')
    fi

    # 检查 id 格式是否正确
    if ! grep -Eix '[0-9a-f]{8}' <<<"$main_disk" &&
        ! grep -Eix '[0-9a-f-]{36}' <<<"$main_disk"; then
        error_and_exit "Disk ID is invalid: $main_disk"
    fi
}

is_found_ipv4_netconf() {
    [ -n "$ipv4_mac" ] && [ -n "$ipv4_addr" ] && [ -n "$ipv4_gateway" ]
}

is_found_ipv6_netconf() {
    [ -n "$ipv6_mac" ] && [ -n "$ipv6_addr" ] && [ -n "$ipv6_gateway" ]
}

# TODO: 单网卡多IP
collect_netconf() {
    if is_in_windows; then
        convert_net_str_to_array() {
            config=$1
            key=$2
            var=$3
            IFS=',' read -r -a "${var?}" <<<"$(grep "$key=" <<<"$config" | cut -d= -f2 | sed 's/[{}\"]//g')"
        }

        # 部分机器精简了 powershell
        # 所以不要用 powershell 获取网络信息
        # ids=$(wmic nic where "PhysicalAdapter=true and MACAddress is not null and (PNPDeviceID like '%VEN_%&DEV_%' or PNPDeviceID like '%{F8615163-DF3E-46C5-913F-F2D2F965ED0E}%')" get InterfaceIndex | sed '1d')

        # 否        手动        0    0.0.0.0/0                  19  192.168.1.1
        # 否        手动        0    0.0.0.0/0                  59  nekoray-tun

        # wmic nic:
        # 真实网卡
        # AdapterType=以太网 802.3
        # AdapterTypeId=0
        # MACAddress=68:EC:C5:11:11:11
        # PhysicalAdapter=TRUE
        # PNPDeviceID=PCI\VEN_8086&amp;DEV_095A&amp;SUBSYS_94108086&amp;REV_61\4&amp;295A4BD&amp;1&amp;00E0

        # VPN tun 网卡，部分移动云电脑也有
        # AdapterType=
        # AdapterTypeId=
        # MACAddress=
        # PhysicalAdapter=TRUE
        # PNPDeviceID=SWD\WINTUN\{6A460D48-FB76-6C3F-A47D-EF97D3DC6B0E}

        # VMware 网卡
        # AdapterType=以太网 802.3
        # AdapterTypeId=0
        # MACAddress=00:50:56:C0:00:08
        # PhysicalAdapter=TRUE
        # PNPDeviceID=ROOT\VMWARE\0001

        for v in 4 6; do
            if [ "$v" = 4 ]; then
                # 或者 route print
                routes=$(netsh int ipv4 show route | awk '$4 == "0.0.0.0/0"')
            else
                routes=$(netsh int ipv6 show route | awk '$4 == "::/0"')
            fi

            if [ -z "$routes" ]; then
                continue
            fi

            while read -r route; do
                if false; then
                    read -r _ _ _ _ id gateway <<<"$route"
                else
                    id=$(awk '{print $5}' <<<"$route")
                    gateway=$(awk '{print $6}' <<<"$route")
                fi

                config=$(wmic nicconfig where InterfaceIndex=$id get MACAddress,IPAddress,IPSubnet,DefaultIPGateway)
                # 排除 IP/子网/网关/MAC 为空的
                if grep -q '=$' <<<"$config"; then
                    continue
                fi

                mac_addr=$(grep "MACAddress=" <<<"$config" | cut -d= -f2 | to_lower)
                convert_net_str_to_array "$config" IPAddress ips
                convert_net_str_to_array "$config" IPSubnet subnets
                convert_net_str_to_array "$config" DefaultIPGateway gateways

                # IPv4
                # shellcheck disable=SC2154
                if [ "$v" = 4 ]; then
                    for ((i = 0; i < ${#ips[@]}; i++)); do
                        ip=${ips[i]}
                        subnet=${subnets[i]}
                        if [[ "$ip" = *.* ]]; then
                            # ipcalc 依赖 perl，会使 cygwin 增加 ~50M
                            # cidr=$(ipcalc -b "$ip/$subnet" | grep Netmask: | awk '{print $NF}')
                            cidr=$(mask2cidr "$subnet")
                            ipv4_addr="$ip/$cidr"
                            ipv4_gateway="$gateway"
                            ipv4_mac="$mac_addr"
                            # 只取第一个 IP
                            break
                        fi
                    done
                fi

                # IPv6
                if [ "$v" = 6 ]; then
                    ipv6_type_list=$(netsh interface ipv6 show address $id normal)
                    for ((i = 0; i < ${#ips[@]}; i++)); do
                        ip=${ips[i]}
                        cidr=${subnets[i]}
                        if [[ "$ip" = *:* ]]; then
                            ipv6_type=$(grep "$ip" <<<"$ipv6_type_list" | awk '{print $1}')
                            # Public 是 slaac
                            # 还有类型 Temporary，不过有 Temporary 肯定还有 Public，因此不用
                            if [ "$ipv6_type" = Public ] ||
                                [ "$ipv6_type" = Dhcp ] ||
                                [ "$ipv6_type" = Manual ]; then
                                ipv6_addr="$ip/$cidr"
                                ipv6_gateway="$gateway"
                                ipv6_mac="$mac_addr"
                                # 只取第一个 IP
                                break
                            fi
                        fi
                    done
                fi

                # 网关
                # shellcheck disable=SC2154
                if false; then
                    for gateway in "${gateways[@]}"; do
                        if [ -n "$ipv4_addr" ] && [[ "$gateway" = *.* ]]; then
                            ipv4_gateway="$gateway"
                        elif [ -n "$ipv6_addr" ] && [[ "$gateway" = *:* ]]; then
                            ipv6_gateway="$gateway"
                        fi
                    done
                fi

                # 如果通过本条 route 的网卡找到了 IP 则退出 routes 循环
                if is_found_ipv${v}_netconf; then
                    break
                fi
            done < <(echo "$routes")
        done
    else
        # linux
        # 通过默认网关得到默认网卡

        # 多个默认路由下
        # ip -6 route show default dev ens3 完全不显示

        # ip -6 route show default
        # default proto static metric 1024 pref medium
        #         nexthop via 2a01:1111:262:4940::2 dev ens3 weight 1 onlink
        #         nexthop via fe80::5054:ff:fed4:5286 dev ens3 weight 1

        # ip -6 route show default
        # default via 2602:1111:0:80::1 dev eth0 metric 1024 onlink pref medium

        # arch + vultr
        # ip -6 route show default
        # default nhid 4011550343 via fe80::fc00:5ff:fe3d:2714 dev enp1s0 proto ra metric 1024 expires 1504sec pref medium

        for v in 4 6; do
            if via_gateway_dev_ethx=$(ip -$v route show default | grep -Ewo 'via [^ ]+ dev [^ ]+' | head -1 | grep .); then
                read -r _ gateway _ ethx <<<"$via_gateway_dev_ethx"
                set_var ipv${v}_ethx "$ethx" # can_use_cloud_kernel 要用
                set_var ipv${v}_mac "$(ip link show dev $ethx | grep link/ether | head -1 | awk '{print $2}')"
                set_var ipv${v}_gateway "$gateway"

                # 获取所有全局地址
                all_addrs=$(ip -$v -o addr show scope global dev $ethx | grep -v temporary | awk '{print $4}')
                primary_addr=$(echo "$all_addrs" | head -1)

                # IPv6: 用 ip route get 让内核返回正确的源 IP，指定 dev 避免 tun/warp 干扰
                if [ "$v" = 6 ] && [ -n "$primary_addr" ]; then
                    route_src=$(ip -6 route get 2001:4860:4860::8888 dev "$ethx" 2>/dev/null | grep -oP 'src \K[^ ]+')
                    if [ -n "$route_src" ]; then
                        for addr in $all_addrs; do
                            if [ "${addr%/*}" = "$route_src" ]; then
                                primary_addr=$addr
                                break
                            fi
                        done
                    fi
                fi

                set_var ipv${v}_addr "$primary_addr"
                # extra_addrs: 除主地址外的所有地址
                set_var ipv${v}_extra_addrs "$(echo "$all_addrs" | grep -Fxve "$primary_addr" | tr '\n' ',' | sed 's/,$//')"
            fi
        done
    fi

    if ! is_found_ipv4_netconf && ! is_found_ipv6_netconf; then
        error_and_exit "Can not get IP info."
    fi

    info "Network Info"
    echo "IPv4 MAC: $ipv4_mac"
    echo "IPv4 Address: $ipv4_addr"
    echo "IPv4 Gateway: $ipv4_gateway"
    echo "---"
    echo "IPv6 MAC: $ipv6_mac"
    echo "IPv6 Address: $ipv6_addr"
    echo "IPv6 Gateway: $ipv6_gateway"
    echo
}

get_efi_dir_in_windows() {
    # 挂载
    if result=$(find /cygdrive/?/EFI/Microsoft/Boot/bootmgfw.efi 2>/dev/null); then
        # 已经挂载
        x=$(echo $result | cut -d/ -f3)
    else
        # 找到空盘符并挂载
        for x in {a..z}; do
            [ ! -e /cygdrive/$x ] && break
        done
        if ! mountvol $x: /s >&2; then
            error_and_exit "Can't mount efi partition in windows."
        fi
    fi
    echo "/cygdrive/$x"
}

add_efi_entry_in_windows() {
    info "Add efi entry in windows"

    local source=$1

    # 文件夹命名为reinstall而不是grub，因为可能机器已经安装了grub，bcdedit名字同理
    dist_dir="$(get_efi_dir_in_windows)/EFI/reinstall"
    efi_drive=$(echo "$dist_dir" | cut -d/ -f3)
    basename=$(basename $source)
    download_or_copy_file "$source" "$dist_dir/$basename"

    # 如果 {fwbootmgr} displayorder 为空
    # 执行 bcdedit /copy '{bootmgr}' 会报错
    # 例如 azure windows 2016 模板
    # 要先设置默认的 {fwbootmgr} displayorder
    # https://github.com/hakuna-m/wubiuefi/issues/286
    bcdedit /set '{fwbootmgr}' displayorder '{bootmgr}' /addfirst

    # 添加启动项
    id=$(bcdedit /copy '{bootmgr}' /d "$(get_entry_name)" | grep -o '{.*}')
    bcdedit /set $id device partition=$efi_drive:
    bcdedit /set $id path \\EFI\\reinstall\\$basename
    bcdedit /set '{fwbootmgr}' bootsequence $id
}

get_maybe_efi_dirs_in_linux() {
    # 不从 fstab 查找，因为极端情况下可能只用 systemd mount
    # arch云镜像efi分区挂载在/efi，且使用 autofs，mount 命令会有两个 /efi 条目

    install_pkg findmnt >&2

    # 寻找 efi 分区，并输出根目录
    # root_dirs=$(mount | awk '$5=="vfat" || $5=="autofs" {print $3}' | grep -Ex '/efi|/boot/efi|/boot' | sort -u)
    root_dirs=$(findmnt -t fat,vfat -n -o TARGET | grep -Ex '/efi|/boot/efi|/boot' | sort -u)

    efi_dirs=$(
        for dir in $root_dirs; do
            # 只显示有 efi 文件的
            # -quit 表示找到第一个 *.efi 就立即退出 find
            if [ -d "$dir" ]; then
                find "$dir" -type f -iname "*.efi" -exec printf '%s\n' "$dir" \; -quit
            fi
        done
    )

    if [ -z "$efi_dirs" ]; then
        error_and_exit "Can't find efi partition."
    fi

    echo "$efi_dirs"
}

get_disk_by_part() {
    dev_part=$1
    install_pkg lsblk >&2
    lsblk -rn --inverse "$dev_part" | grep -w disk | awk '{print $1}'
}

get_part_num_by_part() {
    dev_part=$1
    grep -oE '[0-9]*$' <<<"$dev_part"
}

grep_efi_entry() {
    # efibootmgr
    # BootCurrent: 0002
    # Timeout: 1 seconds
    # BootOrder: 0000,0002,0003,0001
    # Boot0000* sles-secureboot
    # Boot0001* CD/DVD Rom
    # Boot0002* Hard Disk
    # Boot0003* sles-secureboot
    # MirroredPercentageAbove4G: 0.00
    # MirrorMemoryBelow4GB: false

    # 根据文档，* 表示 active，也就是说有可能没有*(代表inactive)
    # https://manpages.debian.org/testing/efibootmgr/efibootmgr.8.en.html
    grep -E '^Boot[0-9a-fA-F]{4}'
}

# trans.sh 有同名方法
grep_efi_index() {
    awk '{print $1}' | sed -e 's/Boot//' -e 's/\*//'
}

download_or_copy_file() {
    local source=$1
    local dist=$2

    mkdir -p "$(dirname $dist)"

    if [[ "$source" = http* ]]; then
        curl -Lo "$dist" "$source"
    else
        cp -f "$source" "$dist"
    fi
}

add_efi_entry_in_linux() {
    local source=$1

    info "Add efi entry in linux"

    install_pkg efibootmgr

    # 只取第一个
    # 因为不用关心是否为 efi 分区，只要是 fat/vfat 格式的分区即可添加到引导
    # 这里用了管道导致 get_maybe_efi_dirs_in_linux 里面的 error_and_exit 不生效
    efi_part=$(get_maybe_efi_dirs_in_linux | head -1 | grep .)
    dist_dir=$efi_part/EFI/reinstall
    basename=$(basename $source)
    download_or_copy_file "$source" "$dist_dir/$basename"

    # 原系统可能不是用 grub 引导，因此不一定有 grub-probe
    if false; then
        grub_probe="$(command -v grub-probe grub2-probe | head -1)"
        dev_part="$("$grub_probe" -t device "$dist_dir")"
    else
        install_pkg findmnt
        # arch findmnt 会得到
        # systemd-1
        # /dev/sda2
        dev_part=$(findmnt -T "$dist_dir" -no SOURCE | grep '^/dev/')
    fi

    set -- efibootmgr --create-only \
        --disk "/dev/$(get_disk_by_part $dev_part)" \
        --part "$(get_part_num_by_part $dev_part)" \
        --label "$(get_entry_name)" \
        --loader "\\EFI\\reinstall\\$basename"

    if ! res=$("$@"); then
        echo "Command: $*"
        echo "$res"
        error_and_exit "Could not add efi entry."
    fi

    id=$(echo "$res" | grep_efi_entry | tail -1 | grep_efi_index | grep .)
    efibootmgr --bootnext "$id"
}

get_grub_efi_filename() {
    case "$basearch" in
    x86_64) echo grubx64.efi ;;
    aarch64) echo grubaa64.efi ;;
    esac
}

install_grub_linux_efi() {
    info 'download grub efi'

    # fedora 39 的 efi 无法识别 opensuse tumbleweed 的 xfs
    efi_distro=fedora

    grub_efi=$(get_grub_efi_filename)

    # 不要用 download.opensuse.org 和 download.fedoraproject.org
    # 因为 ipv6 访问有时跳转到 ipv4 地址，造成 ipv6 only 机器无法下载
    # 日韩机器有时得到国内镜像源，但镜像源屏蔽了国外 IP 导致连不上
    # https://mirrors.bfsu.edu.cn/opensuse/ports/aarch64/tumbleweed/repo/oss/EFI/BOOT/grub.efi

    # fcix 经常 404
    # https://mirror.fcix.net/opensuse/tumbleweed/repo/oss/EFI/BOOT/bootx64.efi
    # https://mirror.fcix.net/opensuse/tumbleweed/appliances/openSUSE-Tumbleweed-Minimal-VM.x86_64-Cloud.qcow2

    # dl.fedoraproject.org 不支持 ipv6

    if [ "$efi_distro" = fedora ]; then
        # fedora 43 efi 在 vultr 无法引导 debain 9/10 netboot
        fedora_ver=$(get_latest_distro_releasever fedora)

        if is_in_china; then
            mirror=https://mirror.nju.edu.cn/fedora
        else
            mirror=https://d2lzkl7pfhq30w.cloudfront.net/pub/fedora/linux
        fi

        curl -Lo $tmp/$grub_efi $mirror/releases/$fedora_ver/Everything/$basearch/os/EFI/BOOT/$grub_efi
    else
        if is_in_china; then
            mirror=https://mirror.nju.edu.cn/opensuse
        else
            mirror=https://downloadcontentcdn.opensuse.org
        fi

        [ "$basearch" = x86_64 ] && ports='' || ports=/ports/$basearch

        curl -Lo $tmp/$grub_efi $mirror$ports/tumbleweed/repo/oss/EFI/BOOT/grub.efi
    fi

    add_efi_entry_in_linux $tmp/$grub_efi
}

download_and_extract_apk() {
    local alpine_ver=$1
    local package=$2
    local extract_dir=$3

    install_pkg tar xz
    is_in_china && mirror=http://mirror.nju.edu.cn/alpine || mirror=https://dl-cdn.alpinelinux.org/alpine
    package_apk=$(curl -L $mirror/v$alpine_ver/main/$basearch/ | grep -oP "$package-[^-]*-[^-]*\.apk" | sort -u)
    if ! [ "$(wc -l <<<"$package_apk")" -eq 1 ]; then
        error_and_exit "find no/multi apks."
    fi
    mkdir -p "$extract_dir"

    # 屏蔽警告
    tar 2>&1 | grep -q BusyBox && tar_args= || tar_args=--warning=no-unknown-keyword
    curl -L "$mirror/v$alpine_ver/main/$basearch/$package_apk" | tar xz $tar_args -C "$extract_dir"
}

install_grub_win() {
    # 下载 grub
    info download grub

    # https://wuyou.net/forum.php?mod=viewthread&tid=449379&extra=page%3D1&page=2

    # 2.14
    # efi  正常
    # bios 报错 ld.gold bug https://lists.gnu.org/archive/html/grub-devel/2026-01/msg00041.html
    #      替换成 alpine/arch 的模块后，出现 ntfs 读取 out of range 错误

    # 2.12
    # efi  报错 __stack_chk_guard https://lists.gnu.org/archive/html/bug-grub/2024-01/msg00002.html
    #      替换成 alpine/arch 的模块后，正常
    # bios 正常

    # 2.06
    # 一切正常

    # 要使用的 grub 版本
    if is_efi; then
        local grub_ver=2.14
    else
        local grub_ver=2.12
    fi

    # grub 对应的 alpine 版本
    case "$grub_ver" in
    2.14) local alpine_ver=3.24 ;;
    2.12) local alpine_ver=3.23 ;;
    2.06) local alpine_ver=3.19 ;;
    esac

    # grub 架构名和对应的 alpine 包名
    if is_efi; then
        local alpine_grub_pkg=grub-efi
        case "$basearch" in
        x86_64) local grub_arch=x86_64-efi ;;
        aarch64) local grub_arch=arm64-efi ;;
        esac
    else
        local alpine_grub_pkg=grub-bios
        local grub_arch=i386-pc
    fi

    # 是否需要从 alpine 获取/替换 grub 模块
    # arm64-efi 要从 alpine 下载 grub 模块
    local need_download_grub_module_from_alpine=false
    if [ "$grub_arch" = arm64-efi ]; then
        need_download_grub_module_from_alpine=true
    fi

    # ftpmirror.gnu.org 是 geoip 重定向，不是 cdn
    # 有可能重定义到一个拉黑了部分 IP 的服务器

    # 换成 ftp.gnu.org?
    is_in_china && grub_url=https://mirror.nju.edu.cn/gnu/grub/grub-$grub_ver-for-windows.zip ||
        grub_url=https://mirrors.kernel.org/gnu/grub/grub-$grub_ver-for-windows.zip
    curl -Lo $tmp/grub.zip $grub_url
    # unzip -qo $tmp/grub.zip
    7z x $tmp/grub.zip -o$tmp -r -y -xr!i386-efi -xr!locale -xr!themes -bso0
    grub_dir=$tmp/grub-$grub_ver-for-windows
    grub=$grub_dir/grub

    # 下载/替换 grub 模块
    if $need_download_grub_module_from_alpine; then
        info 'download grub modules from alpine'
        download_and_extract_apk $alpine_ver $alpine_grub_pkg $tmp/grub-from-alpine
        cp -r $tmp/grub-from-alpine/usr/lib/grub/$grub_arch/ $grub_dir
    fi

    # 设置 grub 包含的模块
    # 原系统是 windows，因此不需要 ext2 lvm xfs btrfs 模块
    # vmlinuz/initramfs 不需要 grub 解压，因此不需要 lzopio xzio gzio zstd 模块
    grub_modules="normal minicmd serial ls echo test cat reboot halt linux chain search all_video configfile"
    grub_modules+=" scsi part_msdos part_gpt fat ntfs ntfscomp"
    if ! is_efi; then
        grub_modules+=" biosdisk linux16"
    fi

    # 设置 grub prefix 为c盘根目录
    # 运行 grub-probe 会改变cmd窗口字体
    local prefix
    prefix=$($grub-probe -t drive $c: | sed 's|.*PhysicalDrive|(hd|' | del_cr)/
    echo $prefix

    # 安装 grub
    if is_efi; then
        # efi
        info install grub for efi

        grub_efi=$(get_grub_efi_filename)
        $grub-mkimage -p $prefix -O $grub_arch -o "$(cygpath -w "$grub_dir/$grub_efi")" $grub_modules
        add_efi_entry_in_windows "$grub_dir/$grub_efi"
    else
        # bios
        info install grub for bios

        # bootmgr 加载 g2ldr 有大小限制
        # 超过大小会报错 0xc000007b
        # 解决方法1 g2ldr.mbr + g2ldr
        # 解决方法2 生成少于64K的 g2ldr + 动态模块
        if false; then
            # g2ldr.mbr
            # 部分国内机无法访问 ftp.cn.debian.org
            is_in_china && host=mirror.nju.edu.cn || host=deb.debian.org
            curl -LO http://$host/debian/tools/win32-loader/oldstable/win32-loader.exe
            7z x win32-loader.exe 'g2ldr.mbr' -o$tmp/win32-loader -r -y -bso0
            find $tmp/win32-loader -name 'g2ldr.mbr' -exec cp {} /cygdrive/$c/ \;

            # g2ldr
            # 配置文件 c:\grub.cfg
            $grub-mkimage -p "$prefix" -O $grub_arch -o "$(cygpath -w $grub_dir/core.img)" $grub_modules
            cat $grub_dir/$grub_arch/lnxboot.img $grub_dir/core.img >/cygdrive/$c/g2ldr
        else
            # grub-install 无法设置 prefix
            # 配置文件 c:\grub\grub.cfg
            $grub-install $c \
                --target=$grub_arch \
                --boot-directory=$c: \
                --install-modules="$grub_modules" \
                --themes= \
                --fonts= \
                --no-bootsector

            cat $grub_dir/$grub_arch/lnxboot.img /cygdrive/$c/grub/$grub_arch/core.img >/cygdrive/$c/g2ldr
        fi

        # 添加引导
        # 脚本可能不是首次运行，所以先删除原来的
        id='{1c41f649-1637-52f1-aea8-f96bfebeecc8}'
        bcdedit /enum all | grep -a $id && bcdedit /delete $id
        bcdedit /create $id /d "$(get_entry_name)" /application bootsector
        bcdedit /set $id device partition=$c:
        bcdedit /set $id path \\g2ldr
        bcdedit /displayorder $id /addlast
        bcdedit /bootsequence $id /addfirst
    fi
}

find_grub_extlinux_cfg() {
    dir=$1
    filename=$2
    keyword=$3

    # 当 ln -s /boot/grub /boot/grub2 时
    # find /boot/ 会自动忽略 /boot/grub2 里面的文件
    cfgs=$(
        # 只要 $dir 存在
        # 无论是否找到结果，返回值都是 0
        find $dir \
            -type f -name $filename \
            -exec grep -E -l "$keyword" {} \;
    )

    count="$(wc -l <<<"$cfgs")"
    if [ "$count" -eq 1 ]; then
        echo "$cfgs"
    else
        error_and_exit "Find $count $filename."
    fi
}

# 空格、&、用户输入的网址要加引号，否则 grub 无法正确识别
is_need_quote() {
    [[ "$1" = *' '* ]] || [[ "$1" = *'&'* ]] || [[ "$1" = http* ]]
}

# 转换 finalos_a=1 为 finalos.a=1 ，排除 finalos_mirrorlist
build_finalos_cmdline() {
    if vars=$(compgen -v finalos_); then
        for key in $vars; do
            value=${!key}
            key=${key#finalos_}
            if [ -n "$value" ] && [ $key != "mirrorlist" ]; then
                is_need_quote "$value" &&
                    finalos_cmdline+=" finalos_$key='$value'" ||
                    finalos_cmdline+=" finalos_$key=$value"
            fi
        done
    fi
}

build_extra_cmdline() {
    # 使用 extra_xxx=yyy 而不是 extra.xxx=yyy
    # 因为 debian installer /lib/debian-installer-startup.d/S02module-params
    # 会将 extra.xxx=yyy 写入新系统的 /etc/modprobe.d/local.conf
    # https://answers.launchpad.net/ubuntu/+question/249456
    # https://salsa.debian.org/installer-team/rootskel/-/blob/master/src/lib/debian-installer-startup.d/S02module-params?ref_type=heads
    for key in confhome hold force_boot_mode force_cn force_old_windows_setup cloud_image no_cloud_kernel main_disk \
        elts deb_mirror \
        username ssh_port rdp_port web_port web_path allow_ping; do
        value=${!key}
        if [ -n "$value" ]; then
            is_need_quote "$value" &&
                extra_cmdline+=" extra_$key='$value'" ||
                extra_cmdline+=" extra_$key=$value"
        fi
    done

    # 指定最终安装系统的 mirrorlist，链接有&，在grub中是特殊字符，所以要加引号
    if [ -n "$finalos_mirrorlist" ]; then
        extra_cmdline+=" extra_mirrorlist='$finalos_mirrorlist'"
    elif [ -n "$nextos_mirrorlist" ]; then
        extra_cmdline+=" extra_mirrorlist='$nextos_mirrorlist'"
    fi

    # cloudcone 特殊处理
    if is_grub_dir_linked; then
        finalos_cmdline+=" extra_link_grub_dir=1"
    fi
}

echo_tmp_ttys() {
    if false; then
        curl -L $confhome/ttys.sh | sh -s "console="
    else
        case "$basearch" in
        x86_64) echo "console=ttyS0,115200n8 console=tty0" ;;
        aarch64) echo "console=ttyS0,115200n8 console=ttyAMA0,115200n8 console=tty0" ;;
        esac
    fi
}

get_entry_name() {
    printf 'reinstall ('
    printf '%s' "$distro"
    [ -n "$releasever" ] && printf ' %s' "$releasever"
    [ "$distro" = alpine ] && [ "$hold" = 1 ] && printf ' Live OS'
    printf ')'
}

# shellcheck disable=SC2154
build_nextos_cmdline() {
    if [ $nextos_distro = alpine ]; then
        nextos_cmdline="alpine_repo=$nextos_repo modloop=$nextos_modloop"
    elif is_distro_like_debian $nextos_distro; then
        # 设置分辨率为800*600，防止分辨率过高 ssh screen attach 后无法全部显示
        # iso 默认有 vga=788
        # 如果要设置位数: video=800x600-16
        nextos_cmdline="lowmem/low=1 auto=true priority=critical"
        # nextos_cmdline+=" vga=788 video=800x600"
        nextos_cmdline+=" preseed/file=/preseed.cfg"
        nextos_cmdline+=" mirror/http/hostname=${nextos_udeb_mirror%/*}"
        nextos_cmdline+=" mirror/http/directory=/${nextos_udeb_mirror##*/}"
        nextos_cmdline+=" base-installer/kernel/image=$nextos_kernel"
        # elts 的 debian 不能用 security 源，否则安装过程会提示无法访问
        if [ "$nextos_distro" = debian ] && is_debian_elts; then
            nextos_cmdline+=" apt-setup/services-select="
        fi
        # kali 安装好后网卡是 eth0 这种格式，但安装时不是
        if [ "$nextos_distro" = kali ]; then
            nextos_cmdline+=" net.ifnames=0"
            nextos_cmdline+=" simple-cdd/profiles=kali"
        fi
    elif is_distro_like_redhat $nextos_distro; then
        # redhat
        nextos_cmdline="root=live:$nextos_squashfs inst.ks=$nextos_ks"
    fi

    if is_distro_like_debian $nextos_distro; then
        if [ "$basearch" = "x86_64" ]; then
            # debian installer 好像第一个 tty 是主 tty
            # 设置ttyS0,tty0,安装界面还是显示在ttyS0
            :
        else
            # debian arm 在没有ttyAMA0的机器上（aws t4g），最少要设置一个tty才能启动
            # 只设置tty0也行，但安装过程ttyS0没有显示
            nextos_cmdline+=" $(echo_tmp_ttys)"
        fi
    else
        nextos_cmdline+=" $(echo_tmp_ttys)"
    fi
    # nextos_cmdline+=" mem=256M"
    # nextos_cmdline+=" lowmem=+1"
}

build_cmdline() {
    # nextos
    build_nextos_cmdline

    # finalos
    # trans 需要 finalos_distro 识别是安装 alpine 还是其他系统
    if [ "$distro" = alpine ]; then
        finalos_distro=alpine
    fi
    if [ -n "$finalos_distro" ]; then
        build_finalos_cmdline
    fi

    # extra
    build_extra_cmdline

    cmdline="$nextos_cmdline $finalos_cmdline $extra_cmdline"
}

# 脚本可能多次运行，先清理之前的残留
mkdir_clear() {
    local dir=$1

    if [ -z "$dir" ] || [ "$dir" = / ]; then
        return
    fi

    # 再次运行时，有可能 mount 了 btrfs root，因此先要 umount_all
    # 但目前不需要 mount ，因此用不到
    # umount_all "$dir"
    rm -rf "$dir"
    mkdir -p "$dir"
}

mod_initrd_debian_kali() {
    # hack 1
    # 允许设置 ipv4 onlink 网关
    sed -Ei 's,&&( onlink=),||\1,' etc/udhcpc/default.script

    # hack 2
    # 强制使用 screen
    # shellcheck disable=SC1003,SC2016
    {
        echo 'if false && : \' | insert_into_file lib/debian-installer.d/S70menu before 'if [ -x "$bterm" ]' -F
        echo 'if true  || : \' | insert_into_file lib/debian-installer.d/S70menu before 'if [ -x "$screen_bin" -a' -F
    }

    # hack 3
    # 修改 /var/lib/dpkg/info/netcfg.postinst 运行我们的脚本
    netcfg() {
        #!/bin/sh
        # shellcheck source=/dev/null
        . /usr/share/debconf/confmodule
        db_progress START 0 5 debian-installer/netcfg/title

        : get_ip_conf_cmd

        # 运行 trans.sh，保存配置
        db_progress INFO base-installer/progress/netcfg
        # 添加 || exit ，可以在 debian installer 不兼容 /trans.sh 语法时强制报错
        # exit 不带参数，返回值为 || 前面命令的返回值
        sh /trans.sh || exit
        db_progress STEP 1
        db_progress STOP
    }

    postinst=var/lib/dpkg/info/netcfg.postinst
    get_function_content netcfg >$postinst
    get_ip_conf_cmd | insert_into_file $postinst after ": get_ip_conf_cmd"
    # cat $postinst

    # hack 4
    # 修改 udeb 依赖

    # 直接覆盖 net-retriever，方便调试
    # curl -Lo /usr/lib/debian-installer/retriever/net-retriever $confhome/net-retriever

    change_priority() {
        while IFS= read -r line; do
            if [[ "$line" = Package:* ]]; then
                package=$(echo "$line" | cut -d' ' -f2-)

            elif [[ "$line" = Priority:* ]]; then
                # shellcheck disable=SC2154
                if [ "$line" = "Priority: standard" ]; then
                    for p in $disabled_list; do
                        if [ "$package" = "$p" ]; then
                            line="Priority: optional"
                            break
                        fi
                    done
                elif [[ "$package" = ata-modules* ]]; then
                    # 改成强制安装
                    # 因为是 pata-modules sata-modules scsi-modules 的依赖
                    # 但我们没安装它们，也就不会自动安装 ata-modules
                    line="Priority: standard"
                fi
            fi
            echo "$line"
        done
    }

    # shellcheck disable=SC2012
    kver=$(ls -d lib/modules/* | awk -F/ '{print $NF}')

    net_retriever=usr/lib/debian-installer/retriever/net-retriever
    # shellcheck disable=SC2016
    sed -i 's,>> "$1",| change_priority >> "$1",' $net_retriever
    insert_into_file $net_retriever after '#!/bin/sh' <<EOF
disabled_list="
depthcharge-tools-installer
kickseed-common
nobootloader
partman-btrfs
partman-cros
partman-iscsi
partman-jfs
partman-md
partman-xfs
rescue-check
wpasupplicant-udeb
lilo-installer
systemd-boot-installer
nic-modules-$kver-di
nic-pcmcia-modules-$kver-di
nic-usb-modules-$kver-di
nic-wireless-modules-$kver-di
nic-shared-modules-$kver-di
pcmcia-modules-$kver-di
pcmcia-storage-modules-$kver-di
cdrom-core-modules-$kver-di
firewire-core-modules-$kver-di
usb-storage-modules-$kver-di
isofs-modules-$kver-di
jfs-modules-$kver-di
xfs-modules-$kver-di
loop-modules-$kver-di
pata-modules-$kver-di
sata-modules-$kver-di
scsi-modules-$kver-di
"

$(get_function change_priority)
EOF

    # https://github.com/linuxhw/LsPCI?tab=readme-ov-file#storageata-pci
    # https://debian.pkgs.org/12/debian-main-amd64/linux-image-6.1.0-18-cloud-amd64_6.1.76-1_amd64.deb.html
    # https://deb.debian.org/debian/pool/main/l/linux-signed-amd64/
    # https://deb.debian.org/debian/dists/bookworm/main/debian-installer/binary-all/Packages.xz
    # https://deb.debian.org/debian/dists/bookworm/main/debian-installer/binary-amd64/Packages.xz
    # 以下是 debian-installer 有的驱动，这些驱动云内核不一定都有，(+)表示云内核有
    # scsi-core-modules 默认安装（不用修改），是 ata-modules 的依赖
    #                   包含 sd_mod.ko(+) scsi_mod.ko(+) scsi_transport_fc.ko(+) scsi_transport_sas.ko(+) scsi_transport_spi.ko(+)
    # ata-modules       默认可选（改成必装），是下方模块的依赖。只有 ata_generic.ko(+) 和 libata.ko(+) 两个驱动

    # pata-modules      默认安装（改成可选），里面的驱动都是 pata_ 开头，但只有 pata_legacy.ko(+) 在云内核中
    # sata-modules      默认安装（改成可选），里面的驱动大部分是 sata_ 开头的，其他重要的还有 ahci.ko libahci.ko ata_piix.ko(+)
    #                   云内核没有 sata 模块，也没有内嵌，有一个 CONFIG_SATA_HOST=y，libata-$(CONFIG_SATA_HOST) += libata-sata.o
    # scsi-modules      默认安装（改成可选），包含 nvme.ko(+) 和各种虚拟化驱动(+)

    download_and_extract_deb() {
        local type=$1
        local package=$2
        local extract_dir=$3

        # shellcheck disable=SC2154
        case "$type" in
        deb)
            local mirror=$nextos_deb_mirror
            local url=http://$mirror/dists/$nextos_codename/main/binary-$basearch_alt/Packages.gz
            ;;
        udeb)
            local mirror=$nextos_udeb_mirror
            local url=http://$mirror/dists/$nextos_codename/main/debian-installer/binary-$basearch_alt/Packages.gz
            ;;
        esac

        # 获取 deb/udeb 列表
        deb_list=$tmp/${type}_list
        if ! [ -f $deb_list ]; then
            curl -L "$url" | zcat | grep 'Filename:' | awk '{print $2}' >$deb_list
        fi

        # 下载 deb/udeb
        deb_path=$(grep -F "/${package}_" "$deb_list")
        curl -Lo $tmp/tmp.deb http://$mirror/"$deb_path"

        if false; then
            # 使用 dpkg
            # cygwin 没有 dpkg
            install_pkg dpkg
            dpkg -x $tmp/tmp.deb $extract_dir
        else
            # 使用 ar tar xz
            # cygwin 需安装 binutils
            # centos7 ar 不支持 --output
            install_pkg ar tar xz
            (cd $tmp && ar x $tmp/tmp.deb)
            tar xf $tmp/data.tar.xz -C $extract_dir
        fi
    }

    cp_debian_kali_driver() {
        # debian 13 的 linux-image.deb 有 /usr/lib 没有 /lib
        # debian 13 的 scsi-modules.udeb 没有 /usr/lib 有 /lib
        local src_drivers_dir=$1/lib/modules/$kver/kernel/drivers
        if ! [ -d "$src_drivers_dir" ]; then
            local src_drivers_dir=$1/usr/lib/modules/$kver/kernel/drivers
        fi
        local extra_drivers=$2
        # 各个版本的 debian/kali installer initrd 都有 /lib
        local dst_drivers_dir=$initrd_dir/lib/modules/$kver/kernel/drivers

        (
            cd $src_drivers_dir
            for driver in $extra_drivers; do
                # debian 模块没有压缩
                # kali 模块有压缩
                # 因此要有 *
                if ! find $dst_drivers_dir -name "$driver.ko*" | grep -q .; then
                    echo "adding driver: $driver"
                    file=$(find . -name "$driver.ko*" | grep .)
                    cp -fv --parents "$file" "$dst_drivers_dir"
                fi
            done
        )
    }

    # 不用在 windows 判断是哪种硬盘控制器，因为 256M 运行 windows 只可能是 xp，而脚本本来就不支持 xp
    # 在 debian installer 中判断能否用云内核
    create_can_use_cloud_kernel_sh can_use_cloud_kernel.sh

    # 下载 fix-eth-name 脚本
    curl -LO "$confhome/fix-eth-name.sh"
    curl -LO "$confhome/fix-eth-name.service"

    # 有段时间 kali initrd 删除了原版 wget
    # 但 initrd 的 busybox wget 又不支持 https
    # 因此改成在这里下载
    curl -LO "$confhome/get-xda.sh"
    curl -LO "$confhome/ttys.sh"
    if [ -n "$frpc_config" ]; then
        curl -LO "$confhome/get-frpc-url.sh"
        curl -LO "$confhome/frpc.service"
    fi

    # 可以节省一点内存？
    echo 'export DEBCONF_DROP_TRANSLATIONS=1' |
        insert_into_file lib/debian-installer/menu before 'exec debconf'

    # 还原 kali netinst.iso 的 simple-cdd 机制
    # 主要用于调用 kali.postinst 设置 zsh 为默认 shell
    # 但 mini.iso 又没有这种机制
    # https://gitlab.com/kalilinux/build-scripts/kali-live/-/raw/main/kali-config/common/includes.installer/kali-finish-install?ref_type=heads
    # https://salsa.debian.org/debian/simple-cdd/-/blob/master/debian/14simple-cdd?ref_type=heads
    # https://http.kali.org/pool/main/s/simple-cdd/simple-cdd-profiles_0.6.9_all.udeb
    if [ "$distro" = kali ]; then
        # 但我们没有使用 iso，因此没有 kali.postinst，需要另外下载
        mkdir -p cdrom/simple-cdd
        curl -Lo cdrom/simple-cdd/kali.postinst https://gitlab.com/kalilinux/build-scripts/kali-live/-/raw/main/kali-config/common/includes.installer/kali-finish-install?ref_type=heads
        chmod a+x cdrom/simple-cdd/kali.postinst
    fi

    # 安装 kali-last-snapshot 时
    # 要将以下几处的 kali-rolling 替换为 kali-last-snapshot
    # 注意系统安装后 /etc/apt/sources.list.d/kali.sources 依然是 kali-rolling
    # kali-linux-202x.x-installer-netinst-amd64.iso 安装后也是 kali-rolling
    # 而微软商店的 kali 的 kali.sources 是 kali-last-snapshot
    if [ "$distro" = kali ] && [ "$releasever" = last-snapshot ]; then
        sed -i "s/kali-rolling/kali-last-snapshot/" \
            preseed.cfg \
            etc/default-release \
            etc/udebs-source
    fi

    # 无论是 netboot kali-last-snapshot 还是 kali-linux-202x.x-installer-netinst-amd64.iso
    # tasksel 安装 openssh-server 时已经在用 /target 的源了，也就是 kali-rolling
    # 我们遇到过 kali-rolling 的 openssh-server 有问题无法安装
    # https://bugs.kali.org/view.php?id=9847
    # https://bugs.kali.org/view.php?id=9853
    # 如果要规避这种情况，或者想安装纯血 kali-last-snapshot
    # debootstrap 后马上修改 apt 源应该可以做到
    # 相关位置 /usr/lib/post-base-installer.d/

    if [ "$distro" = debian ] && is_debian_elts; then
        curl -Lo usr/share/keyrings/debian-archive-keyring.gpg https://deb.freexian.com/extended-lts/archive-key.gpg
    fi

    # 提前下载 sshd
    # 以便在配置下载源之前就可以启动 sshd
    mkdir_clear $tmp/sshd
    download_and_extract_deb udeb openssh-server-udeb $tmp/sshd
    cp -r $tmp/sshd/* .

    # 提前下载 fdisk
    # 因为 fdisk-udeb 包含 fdisk 和 sfdisk，提前下载可减少占用
    mkdir_clear $tmp/fdisk
    download_and_extract_deb udeb fdisk-udeb $tmp/fdisk
    cp -f $tmp/fdisk/usr/sbin/fdisk usr/sbin/

    # 下载 websocketd
    # debian 11+ 才有 websocketd
    if [ "$distro" = kali ] ||
        { [ "$distro" = debian ] && [ "$releasever" -ge 11 ]; }; then
        mkdir_clear $tmp/websocketd
        download_and_extract_deb deb websocketd $tmp/websocketd
        cp -f $tmp/websocketd/usr/bin/websocketd usr/bin/
    fi

    # 提前下载 pci-hyperv
    # udeb 没有这个模块 curl https://deb.debian.org/debian/dists/stable/main/Contents-udeb-amd64.gz | zcat | grep pci-hyperv
    # 缺少这个模块 azure 会找不到 nvme 硬盘
    # kali 的 pci-hyperv/pci-hyperv-intf 已嵌入到内核，不需要下载

    # 用到 pci-hyperv 才需要下载，因为
    # 1. azure 普通网卡、scsi 硬盘不需要这个模块
    # 2. 没有这个模块会缺少加速网卡，但还有 hyperv 合成网卡，可以正常上网
    if { is_in_windows && wmic PATH Win32_PnPEntity where "DeviceID like 'VMBUS\\\\{44C4F61D-4444-4400-9D52-802E27EDE19F}\\\\%'" | grep -q . ||
        [ -d /sys/module/pci_hyperv ]; } &&
        # 可能在 host 或 controller 文件夹
        ! ls lib/modules/$kver/kernel/drivers/pci/*/pci-hyperv.ko* >/dev/null 2>&1 &&
        ! grep -Fq /pci-hyperv.ko lib/modules/$kver/modules.builtin; then
        mkdir_clear $tmp/linux-image-$kver
        download_and_extract_deb deb linux-image-$kver $tmp/linux-image-$kver
        cp_debian_kali_driver $tmp/linux-image-$kver pci-hyperv
    fi

    # >256M 或者当前系统是 windows
    if [ $ram_size -gt 256 ] || is_in_windows; then
        sed -i '/^pata-modules/d' $net_retriever
        sed -i '/^sata-modules/d' $net_retriever
        sed -i '/^scsi-modules/d' $net_retriever
    else
        # <=256M 极限优化
        find_main_disk
        extra_drivers=
        for driver in $(get_disk_drivers $xda); do
            echo "using driver: $driver"
            case $driver in
            nvme)
                extra_drivers+=" nvme nvme-core"
                # debian 13+ / kali 有 nvme-auth 模块
                # 添加后才能识别 nvme 硬盘
                if grep -q nvme-auth lib/modules/$kver/modules.order; then
                    extra_drivers+=" nvme-auth"
                fi
                ;;
            # xen 的横杠特别不同
            xen_blkfront) extra_drivers+=" xen-blkfront" ;;
            xen_scsifront) extra_drivers+=" xen-scsifront" ;;
            virtio_blk | virtio_scsi | hv_storvsc | vmw_pvscsi) extra_drivers+=" $driver" ;;
            pata_legacy) sed -i '/^pata-modules/d' $net_retriever ;; # 属于 pata-modules
            ata_piix) sed -i '/^sata-modules/d' $net_retriever ;;    # 属于 sata-modules
            ata_generic) ;;                                          # 属于 ata-modules，不用处理，因为我们设置强制安装了 ata-modules
            esac
        done

        # extra drivers
        # xen 还需要以下两个？
        # kernel/drivers/xen/xen-scsiback.ko
        # kernel/drivers/block/xen-blkback/xen-blkback.ko
        # udeb 没有这个模块 curl https://deb.debian.org/debian/dists/stable/main/Contents-udeb-amd64.gz | zcat | grep xen
        if [ -n "$extra_drivers" ]; then
            mkdir_clear $tmp/scsi
            download_and_extract_deb udeb scsi-modules-$kver-di $tmp/scsi
            cp_debian_kali_driver $tmp/scsi "$extra_drivers"
        fi
    fi

    # amd64)
    #   level1=737 # MT=754108, qemu: -m 780
    #   level2=424 # MT=433340, qemu: -m 460
    #   min=316    # MT=322748, qemu: -m 350

    # 将 use_level 2 9 修改为 use_level 1
    # x86 use_level 2 会出现 No root file system is defined.
    # arm 即使 use_level 1 也会出现 No root file system is defined.
    sed -i 's/use_level=[29]/use_level=1/' lib/debian-installer-startup.d/S15lowmem

    # hack 3
    # 修改 trans.sh
    # 1. 直接调用 create_ifupdown_config
    # shellcheck disable=SC2154
    insert_into_file $initrd_dir/trans.sh after '^: main' <<EOF
        distro=$nextos_distro
        releasever=$nextos_releasever
        create_ifupdown_config /etc/network/interfaces
        exit
EOF
    # 2. 删除 debian busybox 无法识别的语法
    # 3. 删除 apk 语句
    # 4. debian 11/12 initrd 无法识别 > >
    # 5. debian 11/12 initrd 无法识别 < < ，注意可能分两行写
    # 6. debian 11 initrd 无法识别 set -E
    # 7. debian 11 initrd 无法识别 trap ERR
    # 8. debian 9 initrd 无法识别 ${string//find/replace}
    # 9. debian 12 initrd 无法识别 . <(
    # 删除或注释，可能会导致空方法而报错，因此改为替换成'\n: #'
    replace='\n: #'
    sed -Ei \
        -e "s/> >/$replace/" \
        -e "s/< </$replace/" \
        -e "s/\. <\(/$replace/" \
        -e "s/< \\\\/$replace/" \
        -e "s/ <\(/$replace/" \
        -e "s/^[[:space:]]*apk[[:space:]]/$replace/" \
        -e "s/^[[:space:]]*trap[[:space:]]/$replace/" \
        -e "s/\\$\{.*\/\/.*\/.*\}/$replace/" \
        -e "/^[[:space:]]*set[[:space:]]/s/E//" \
        $initrd_dir/trans.sh

    # ubuntu 22.04 不支持这种语法，bash -n 会报错
    # 因此不验证 trans.sh 的语法
    # a=$(
    #     case 1 in
    #     1)
    #         case 1 in
    #         1) echo ;;
    #         2) echo ;;
    #         esac
    #         ;;
    #     2)
    #         case 1 in
    #         1) echo ;;
    #         2) echo ;;
    #         esac
    #         ;;
    #     esac
    # )

    # 测试魔改后的 trans.sh 有没有语法问题
    # bash -n $initrd_dir/trans.sh
}

get_disk_drivers() {
    get_drivers "/sys/block/$1"
}

get_net_drivers() {
    get_drivers "/sys/class/net/$1"
}

# 不用在 windows 判断是哪种硬盘/网络驱动，因为 256M 运行 windows 只可能是 xp，而脚本本来就不支持 xp
# 而且安装过程也有二次判断
# trans.sh 有同名方法
get_drivers() {
    # 有以下结果组合出现
    # sd_mod
    # virtio_blk
    # virtio_scsi
    # virtio_pci
    # pcieport
    # xen_blkfront
    # ahci
    # nvme
    # pci_hyperv
    # mptspi
    # mptsas
    # vmw_pvscsi
    (
        cd "$(readlink -f $1)"
        while ! [ "$(pwd)" = / ]; do
            if [ -d driver ]; then
                if [ -d driver/module ]; then
                    # 显示全名，例如 xen_blkfront sd_mod
                    # 但 ahci 没有这个文件，所以 else 不能省略
                    basename "$(readlink -f driver/module)"
                else
                    # 不显示全名，例如 vbd sd
                    basename "$(readlink -f driver)"
                fi
            fi
            cd ..
        done
    )
}

exit_if_cant_use_cloud_kernel() {
    find_main_disk
    collect_netconf

    # shellcheck disable=SC2154
    if ! can_use_cloud_kernel "$xda" $ipv4_ethx $ipv6_ethx; then
        error_and_exit "Can't use cloud kernel. And not enough RAM to run normal kernel."
    fi
}

can_use_cloud_kernel() {
    # initrd 下也要使用，不要用 <<<

    # 有些虚拟机用了 ahci，但云内核没有 ahci 驱动
    cloud_eth_modules='ena|gve|mana|virtio_net|xen_netfront|hv_netvsc|vmxnet3|mlx4_en|mlx4_core|mlx5_core|ixgbevf'
    cloud_blk_modules='ata_generic|ata_piix|pata_legacy|nvme|virtio_blk|virtio_scsi|xen_blkfront|xen_scsifront|hv_storvsc|vmw_pvscsi'

    # disk
    drivers="$(get_disk_drivers $1)"
    shift
    for driver in $drivers; do
        echo "using disk driver: $driver"
    done
    echo "$drivers" | grep -Ewq "$cloud_blk_modules" || return 1

    # net
    # v4 v6 eth 相同，只检查一次
    if [ "$1" = "$2" ]; then
        shift
    fi
    while [ $# -gt 0 ]; do
        drivers="$(get_net_drivers $1)"
        shift
        for driver in $drivers; do
            echo "using net driver: $driver"
        done
        echo "$drivers" | grep -Ewq "$cloud_eth_modules" || return 1
    done
}

create_can_use_cloud_kernel_sh() {
    cat <<EOF >$1
        $(get_function get_drivers)
        $(get_function get_net_drivers)
        $(get_function get_disk_drivers)
        $(get_function can_use_cloud_kernel)

        can_use_cloud_kernel "\$@"
EOF
}

get_ip_conf_cmd() {
    collect_netconf >&2
    is_in_china && is_in_china=true || is_in_china=false

    sh=/initrd-network.sh
    if is_found_ipv4_netconf && is_found_ipv6_netconf && [ "$ipv4_mac" = "$ipv6_mac" ]; then
        echo "'$sh' '$ipv4_mac' '$ipv4_addr' '$ipv4_gateway' '$ipv6_addr' '$ipv6_gateway' '$is_in_china' '$ipv6_extra_addrs'"
    else
        if is_found_ipv4_netconf; then
            echo "'$sh' '$ipv4_mac' '$ipv4_addr' '$ipv4_gateway' '' '' '$is_in_china' ''"
        fi
        if is_found_ipv6_netconf; then
            echo "'$sh' '$ipv6_mac' '' '' '$ipv6_addr' '$ipv6_gateway' '$is_in_china' '$ipv6_extra_addrs'"
        fi
    fi
}

is_need_web_viewer() {
    ! { [ "$distro" = netboot.xyz ] || is_alpine_live; }
}

mod_initrd_alpine() {
    # hack 1 v3.19 和之前的 virt 内核需添加 ipv6 模块
    if virt_dir=$(ls -d $initrd_dir/lib/modules/*-virt 2>/dev/null); then
        ipv6_dir=$virt_dir/kernel/net/ipv6
        if ! [ -f $ipv6_dir/ipv6.ko ] && ! grep -q ipv6 $initrd_dir/lib/modules/*/modules.builtin; then
            mkdir -p $ipv6_dir
            modloop_file=$tmp/modloop_file
            modloop_dir=$tmp/modloop_dir
            curl -Lo $modloop_file $nextos_modloop
            if is_in_windows; then
                # cygwin 没有 unsquashfs
                7z e $modloop_file ipv6.ko -r -y -o$ipv6_dir
            else
                install_pkg unsquashfs
                mkdir_clear $modloop_dir
                unsquashfs -f -d $modloop_dir $modloop_file 'modules/*/kernel/net/ipv6/ipv6.ko'
                find $modloop_dir -name ipv6.ko -exec cp {} $ipv6_dir/ \;
            fi
        fi
    fi

    # hack 下载 dhcpcd
    # shellcheck disable=SC2154
    download_and_extract_apk "$nextos_releasever" dhcpcd "$initrd_dir"
    sed -i -e '/^slaac private/s/^/#/' -e '/^#slaac hwaddr/s/^#//' $initrd_dir/etc/dhcpcd.conf

    # hack 2 /usr/share/udhcpc/default.script
    # 脚本被调用的顺序
    # udhcpc:  deconfig
    # udhcpc:  bound
    # udhcpc6: deconfig
    # udhcpc6: bound
    # shellcheck disable=SC2329
    udhcpc() {
        if [ "$1" = deconfig ]; then
            return
        fi
        if [ "$1" = bound ] && [ -n "$ipv6" ]; then
            # shellcheck disable=SC2154
            ip -6 addr add "$ipv6" dev "$interface"
            ip link set dev "$interface" up
            return
        fi
    }

    get_function_content udhcpc |
        insert_into_file usr/share/udhcpc/default.script after 'deconfig\|renew\|bound'

    # 允许设置 ipv4 onlink 网关
    sed -Ei 's,(0\.0\.0\.0\/0),"\1 onlink",' usr/share/udhcpc/default.script

    # hack 3 网络配置
    # alpine 根据 MAC_ADDRESS 判断是否有网络
    # https://github.com/alpinelinux/mkinitfs/blob/c4c0115f9aa5aa8884c923dc795b2638711bdf5c/initramfs-init.in#L914
    insert_into_file init after 'configure_ip\(\)' <<EOF
        depmod
        [ -d /sys/module/ipv6 ] || modprobe ipv6
        $(get_ip_conf_cmd)
        MAC_ADDRESS=1
        return
EOF

    # grep -E -A5 'configure_ip\(\)' init

    # hack 4 运行 trans.start
    # 1. alpine arm initramfs 时间问题 要添加 --no-check-certificate
    # 2. aws t4g arm 如果没设置console=ttyx，在initramfs里面wget https会出现bad header错误，chroot后正常
    # Connecting to raw.githubusercontent.com (185.199.108.133:443)
    # 60C0BB2FFAFF0000:error:0A00009C:SSL routines:ssl3_get_record:http request:ssl/record/ssl3_record.c:345:
    # ssl_client: SSL_connect
    # wget: bad header line: �
    insert_into_file init before '^exec switch_root' <<EOF
        # trans
        # echo "wget --no-check-certificate -O- $confhome/trans.sh | /bin/ash" >\$sysroot/etc/local.d/trans.start
        # wget --no-check-certificate -O \$sysroot/etc/local.d/trans.start $confhome/trans.sh
        cp /trans.sh \$sysroot/etc/local.d/trans.start
        chmod a+x \$sysroot/etc/local.d/trans.start
        ln -s /etc/init.d/local \$sysroot/etc/runlevels/default/

        # 配置 + 自定义驱动
        for dir in /configs /custom_drivers; do
            if [ -d \$dir ]; then
                cp -r \$dir \$sysroot/
                rm -rf \$dir
            fi
        done
EOF

    # 判断云镜像 debain 能否用云内核
    if is_distro_like_debian; then
        create_can_use_cloud_kernel_sh can_use_cloud_kernel.sh
        insert_into_file init before '^exec (/bin/busybox )?switch_root' <<EOF
        cp /can_use_cloud_kernel.sh \$sysroot/
        chmod a+x \$sysroot/can_use_cloud_kernel.sh
EOF
    fi
}

mod_initrd() {
    info "mod $nextos_distro initrd"
    install_pkg gzip cpio

    # 解压
    # 先删除临时文件，避免之前运行中断有残留文件
    initrd_dir=$tmp/initrd
    mkdir_clear $initrd_dir
    cd $initrd_dir

    # cygwin 下处理 debian initrd 时
    # 解压/重新打包/删除 initrd 的 /dev/console /dev/null 都会报错
    # cpio: dev/console: Cannot utime: Invalid argument
    # cpio: ./dev/console: Cannot stat: Bad address
    # 用 windows 文件管理器可删除

    # 但同样运行 zcat /reinstall-initrd | cpio -idm
    # 打开 C:\cygwin\Cygwin.bat ，运行报错
    # 打开桌面的 Cygwin 图标，运行就没问题

    # shellcheck disable=SC2046
    # nonmatching 是精确匹配路径
    zcat /reinstall-initrd | cpio -idm \
        $(is_in_windows && echo --nonmatching 'dev/console' --nonmatching 'dev/null')

    curl -Lo $initrd_dir/trans.sh $confhome/trans.sh
    if ! grep -iq "$SCRIPT_VERSION" $initrd_dir/trans.sh; then
        error_and_exit "
This script is outdated, please download reinstall.sh again.
脚本有更新，请重新下载 reinstall.sh"
    fi

    curl -Lo $initrd_dir/initrd-network.sh $confhome/initrd-network.sh
    chmod a+x $initrd_dir/trans.sh $initrd_dir/initrd-network.sh

    # 保存配置
    mkdir -p $initrd_dir/configs
    if [ -n "$ssh_keys" ]; then
        cat <<<"$ssh_keys" >$initrd_dir/configs/ssh_keys
    else
        save_password $initrd_dir/configs
    fi
    if [ -n "$frpc_config" ]; then
        cat "$frpc_config" >$initrd_dir/configs/frpc.conf
    fi

    # 收集 cloud-data 打包进 initrd
    if [ -n "$cloud_data" ]; then
        mkdir -p $initrd_dir/configs/cloud-data
        if [ -d "$cloud_data" ]; then
            # 本地目录：直接复制
            cp "$cloud_data"/* $initrd_dir/configs/cloud-data/
        else
            # URL：在 host 下载
            for f in user-data meta-data network-config; do
                curl -fsSL "$cloud_data/$f" -o "$initrd_dir/configs/cloud-data/$f" 2>/dev/null || true
            done
        fi
        # 校验：至少要有 user-data
        [ -f $initrd_dir/configs/cloud-data/user-data ] || error_and_exit "--cloud-data must contain user-data"
        cloud_data_files=$(ls $initrd_dir/configs/cloud-data/ | tr '\n' ' ')
    fi

    if is_distro_like_debian $nextos_distro; then
        mod_initrd_debian_kali
    else
        mod_initrd_$nextos_distro
    fi

    # 添加自定义 windows 驱动
    if [ "$distro" = windows ] && [ -n "$custom_infs" ]; then
        # shellcheck disable=SC1090
        . <(curl -L $confhome/windows-driver-utils.sh)
        echo "$custom_infs" | while read -r inf; do
            parse_inf_and_cp_driever "$inf" "$initrd_dir/custom_drivers" "$basearch_alt" true
        done
    fi

    # alpine live 不精简 initrd
    # 因为不知道用户想干什么，可能会用到精简的文件
    if is_virt && ! is_alpine_live; then
        remove_useless_initrd_files
    fi

    if [ "$hold" = 0 ]; then
        info 'hold 0'
        echo "Edit $tmp if needed."
        read -r -p 'Press Enter to continue...'
    fi

    # 重建
    # 注意要用 cpio -H newc 不要用 cpio -c ，不同版本的 -c 作用不一样，很坑
    # -c    Use the old portable (ASCII) archive format
    # -c    Identical to "-H newc", use the new (SVR4)
    #       portable format.If you wish the old portable
    #       (ASCII) archive format, use "-H odc" instead.
    fleet_customize_initrd "$initrd_dir"
    (set -o pipefail; find . | cpio --quiet -o -H newc -R 0:0 | gzip -1 >/reinstall-initrd.new) || return
    gzip -t /reinstall-initrd.new || return
    mv -f /reinstall-initrd.new /reinstall-initrd
    cd - >/dev/null
}

remove_useless_initrd_files() {
    info "slim initrd"

    # 显示精简前的大小
    du -sh .

    # 删除 initrd 里面没用的文件/驱动
    rm -rf bin/brltty
    rm -rf etc/brltty
    rm -rf sbin/wpa_supplicant
    rm -rf usr/lib/libasound.so.*
    rm -rf usr/share/alsa
    (
        cd lib/modules/*/kernel/drivers/net/ethernet/
        for item in *; do
            case "$item" in
            # 甲骨文 arm 用自定义镜像支持设为 mlx5 vf 网卡，且不是 azure 那样显示两个网卡
            # https://debian.pkgs.org/13/debian-main-amd64/linux-image-6.12.43+deb13-cloud-amd64_6.12.43-1_amd64.deb.html
            amazon | google | mellanox | realtek | pensando) ;;
            intel)
                (
                    cd "$item"
                    for sub_item in *; do
                        case "$sub_item" in
                        # 有 e100.ko e1000文件夹 e1000e文件夹
                        e100* | lib* | *vf | idpf) ;;
                        *) rm -rf $sub_item ;;
                        esac
                    done
                )
                ;;
            *) rm -rf $item ;;
            esac
        done
    )
    (
        cd lib/modules/*/kernel
        for item in \
            net/mac80211 \
            net/wireless \
            net/bluetooth \
            drivers/hid \
            drivers/mtd \
            drivers/usb \
            drivers/ssb \
            drivers/mfd \
            drivers/bcma \
            drivers/pcmcia \
            drivers/parport \
            drivers/platform \
            drivers/staging \
            drivers/net/usb \
            drivers/net/bonding \
            drivers/net/wireless \
            drivers/input/rmi4 \
            drivers/input/keyboard \
            drivers/input/touchscreen \
            drivers/bus/mhi \
            drivers/char/pcmcia \
            drivers/misc/cardreader; do
            rm -rf $item
        done
    )

    # 显示精简后的大小
    du -sh .
}

get_unix_path() {
    if is_in_windows; then
        # 输入的路径是 / 开头也没问题
        cygpath -u "$1"
    else
        printf '%s' "$1"
    fi
}

init_basearch() {
    # 设置 basearch
    if is_in_windows; then
        # x86-based PC
        # x64-based PC
        # ARM-based PC
        # ARM64-based PC

        # 三种方法都不需要管理员运行
        if false; then
            # 如果机器没有 wmic 则需要下载 wmic.ps1，但此时未判断国内外，还是用国外源
            basearch=$(wmic ComputerSystem get SystemType | grep '=' | cut -d= -f2 | cut -d- -f1)
        elif true; then
            basearch=$(reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v PROCESSOR_ARCHITECTURE |
                grep . | tail -1 | awk '{print $NF}')
        else
            # 也可以用
            basearch=$(cmd /c "if defined PROCESSOR_ARCHITEW6432 (echo %PROCESSOR_ARCHITEW6432%) else (echo %PROCESSOR_ARCHITECTURE%)")
        fi
    else
        # archlinux 云镜像没有 arch 命令
        # https://en.wikipedia.org/wiki/Uname
        basearch=$(uname -m)
    fi

    # 统一架构名称，并强制 64 位
    case "$(echo $basearch | to_lower)" in
    i?86 | x64 | x86* | amd64)
        basearch=x86_64
        basearch_alt=amd64
        ;;
    arm* | aarch64)
        basearch=aarch64
        basearch_alt=arm64
        ;;
    *) error_and_exit "Unsupported arch: $basearch" ;;
    esac
}

init_confhome() {
    # 设置 confhome
    # 未测试
    if false && [[ "$confhome" = http*://raw.githubusercontent.com/* ]]; then
        repo=$(echo $confhome | cut -d/ -f4,5)
        branch=$(echo $confhome | cut -d/ -f6)
        # 避免脚本更新时，文件不同步造成错误
        if [ -z "$commit" ]; then
            commit=$(curl -L https://api.github.com/repos/$repo/git/refs/heads/$branch |
                grep '"sha"' | grep -Eo '[0-9a-f]{40}')
        fi
        # shellcheck disable=SC2001
        confhome=$(echo "$confhome" | sed "s/main$/$commit/")
    fi

    # 设置国内代理
    # 要在使用 wmic 前设置，否则国内机器会从国外源下载 wmic.ps1
    # gitee 不支持ipv6
    # jsdelivr 有12小时缓存
    # https://github.com/XIU2/UserScript/blob/master/GithubEnhanced-High-Speed-Download.user.js#L31
    if is_in_china; then
        if [ -n "$confhome_cn" ]; then
            confhome=$confhome_cn
        elif [ -n "$github_proxy" ] && [[ "$confhome" = http*://raw.githubusercontent.com/* ]]; then
            confhome=${confhome/http:\/\//https:\/\/}
            confhome=${confhome/https:\/\/raw.githubusercontent.com/$github_proxy}
        fi
    fi
}

remove_exist_reinstall_efi_dir() {
    info "remove exist reinstall efi dir"

    local dir='' dirs=''
    if is_in_windows; then
        dirs=$(get_efi_dir_in_windows)
    else
        dirs=$(get_maybe_efi_dirs_in_linux)
    fi
    # 后期可能会将 reinstall-vmlinuz 和 reinstall-initrd 放到 efi 分区下
    # 因此也删除它们
    for dir in $dirs; do
        rm -f "$dir/reinstall-vmlinuz"
        rm -f "$dir/reinstall-initrd"
    done
    find $dirs -type f \
        \( -ipath '*/EFI/reinstall/grubx64.efi' \
        -o -ipath '*/EFI/reinstall/grubaa64.efi' \
        -o -ipath '*/EFI/reinstall/netboot.xyz.efi' \
        -o -ipath '*/EFI/reinstall/netboot.xyz-arm64.efi' \) |
        while IFS= read -r efi_file; do
            reinstall_dir=$(dirname "$efi_file")
            echo "removing $reinstall_dir"
            rm -rf "$reinstall_dir"
        done
}

#             linux                                      windows
# bios        /boot/grub*/custom.cfg                     /cygdrive/c/grub/grub.cfg
# efi         efi分区的/EFI/reinstall/grub.cfg           /cygdrive/c/grub.cfg
# efi文件夹    efi分区的/EFI/reinstall/                  /cygdrive/a/EFI/reinstall/

init_bootloader_facts() {
    if is_in_windows; then
        # windows
        if is_efi; then
            _grub_cfg=/cygdrive/$c/grub.cfg
        else
            _grub_cfg=/cygdrive/$c/grub/grub.cfg
        fi
        target_cfg=$_grub_cfg
    else
        # linux
        if is_efi; then
            efi_dir=$(get_maybe_efi_dirs_in_linux | head -1)
            _grub_cfg=$efi_dir/EFI/reinstall/grub.cfg
            target_cfg=$_grub_cfg
        else
            if is_mbr_using_grub; then
                if is_have_cmd update-grub; then
                    # alpine debian ubuntu
                    _grub_cfg=$(grep -o '[^ ]*grub.cfg' "$(get_cmd_path update-grub)" | head -1)
                else
                    # 找出主配置文件（含有menuentry|blscfg）
                    # 有没有可能在 efi 目录?
                    _grub_cfg=$(find_grub_extlinux_cfg '/boot/grub*' grub.cfg 'menuentry|blscfg')
                fi
                target_cfg=$(dirname $_grub_cfg)/custom.cfg

                if is_have_cmd grub2-mkconfig; then
                    grub=grub2
                elif is_have_cmd grub-mkconfig; then
                    grub=grub
                else
                    error_and_exit "grub not found"
                fi
            else
                # extlinux
                _extlinux_cfg=$(find_grub_extlinux_cfg /boot extlinux.conf LINUX)
                target_cfg=$_extlinux_cfg
            fi
        fi
    fi
}

# 重新生成 grub.cfg
# 因为有些机子例如hython debian的grub.cfg少了40_custom 41_custom 部分
recreate_grub_or_extlinux_cfg() {
    # 没用到原机的 grub 和 extlinux
    # 因此不需要重新生成 grub.cfg 或 extlinux.conf
    if is_efi || is_in_windows; then
        return
    fi

    if is_mbr_using_grub; then
        info "recreate grub.cfg"

        # nixos 手动执行 grub-mkconfig -o /boot/grub/grub.cfg 会丢失系统启动条目
        # 正确的方法是修改 configuration.nix 的 boot.loader.grub.extraEntries
        # 但是修改 configuration.nix 不是很好，因此改成修改 grub.cfg
        if [ -x /nix/var/nix/profiles/system/bin/switch-to-configuration ]; then
            # 生成 grub.cfg
            /nix/var/nix/profiles/system/bin/switch-to-configuration boot
            # 手动启用 41_custom
            nixos_grub_home="$(dirname "$(readlink -f "$(get_cmd_path grub-mkconfig)")")/.."
            $nixos_grub_home/etc/grub.d/41_custom >>"$(dirname "$target_cfg")/grub.cfg"
        elif is_have_cmd update-grub; then
            update-grub
        else
            $grub-mkconfig -o $target_cfg
        fi
    elif is_have_cmd update-extlinux; then
        # alpine 才有 update-extlinux
        info "recreate extlinux.conf"
        update-extlinux
    else
        error_and_exit "unsupported bootloader."
    fi
}

# 删除之前的 reinstall 启动项
remove_exist_reinstall() {
    info "remove exist reinstall"

    rm -f /reinstall-vmlinuz /reinstall-initrd
    rm -f /boot/reinstall-vmlinuz /boot/reinstall-initrd
    if is_in_windows; then
        rm -f /cygdrive/$c/reinstall-vmlinuz /cygdrive/$c/reinstall-initrd
    fi

    # 使用外部 grub 时，删除外部 grub.cfg
    if ! is_use_local_grub_extlinux; then
        rm -f "$target_cfg"
    fi

    if is_in_windows; then
        if is_efi; then
            # efi
            remove_exist_reinstall_efi_dir

            bcdedit /set '{fwbootmgr}' bootsequence '{bootmgr}'
            bcdedit /enum bootmgr | grep -a -B3 'reinstall' | awk '{print $2}' | grep '{.*}' |
                xargs -I {} cmd /c bcdedit /delete {}
        else
            # bios
            id='{1c41f649-1637-52f1-aea8-f96bfebeecc8}'
            if bcdedit /enum all | grep -a "$id"; then
                bcdedit /delete "$id"
            fi
        fi
    else
        if is_efi; then
            # efi

            # 题外话
            # 1. 如果用本机的 grub，则 custom.cfg 可能在 efi 分区，也可能在 /boot 分区
            # 2. 有可能没有 /boot 文件夹
            #    如果 nixos 的 efi 挂载到 /efi，则不会生成 /boot 文件夹
            # 3. find 不存在的路径会报错
            remove_exist_reinstall_efi_dir

            install_pkg efibootmgr
            efibootmgr | grep -q 'BootNext:' && efibootmgr --quiet --delete-bootnext
            efibootmgr | grep_efi_entry | grep 'reinstall' | grep_efi_index |
                xargs -I {} efibootmgr --quiet --bootnum {} --delete-bootnum
        else
            # bios

            # 删除 reinstall 条目
            if [ -f "$target_cfg" ]; then
                sed -i "/^$BOOT_ENTEY_START_MARK/,/^$BOOT_ENTEY_END_MARK/d" "$target_cfg"
            fi

            # 清除 next entry
            if is_use_local_grub; then
                $grub-editenv - unset next_entry
            elif is_use_local_extlinux; then
                extlinux --clear-once "$(dirname "$target_cfg")"
            fi

            # 重新创建 grub.cfg / extlinux.conf
            recreate_grub_or_extlinux_cfg
        fi
    fi
}

reset_and_exit() {
    from_ctrl_c=${1:-false}

    # info
    if $from_ctrl_c; then
        info "Caught Ctrl+C, reseting..."
    fi

    # 清除
    remove_exist_reinstall
    rm -rf "$tmp"
    echo "reset done."

    # 退出
    if $from_ctrl_c; then
        exit 1
    else
        exit 0
    fi
}

# 脚本入口

# windows 环境下的额外初始化
if is_in_windows; then
    # win系统盘
    c=$(echo $SYSTEMDRIVE | cut -c1)

    # 64位系统 + 32位cmd/cygwin，需要添加 PATH，否则找不到64位系统程序，例如bcdedit
    sysnative=$(cygpath -u $WINDIR\\Sysnative)
    if [ -d $sysnative ]; then
        PATH=$PATH:$sysnative
    fi

    # 更改 windows 命令输出语言为英文
    # chcp 会清屏
    mode.com con cp select=437 >/dev/null

    # 为 windows 程序输出删除 cr
    for exe in $WINDOWS_EXES; do
        # 如果我们覆写了 wmic()，则先将 wmic() 重命名为 _wmic()
        if get_function $exe >/dev/null 2>&1; then
            eval "_$(get_function $exe)"
        fi
        # 使用以下方法重新生成 wmic()
        # 调用链：wmic() -> run_with_del_cr(wmic) -> _wmic() -> command wmic
        eval "$exe(){ $(get_function_content run_with_del_cr_template | sed "s/\$exe/$exe/g") }"
    done
fi

# 检查 root
if is_in_windows; then
    # 64位系统 + 32位cmd/cygwin，运行 openfiles 报错：目标系统必须运行 32 位的操作系统
    if ! fltmc >/dev/null 2>&1; then
        error_and_exit "Please run as administrator."
    fi
else
    if [ "$EUID" -ne 0 ]; then
        error_and_exit "Please run as root."
    fi
fi

# 不支持 Live OS 下运行
if mount | grep -q 'tmpfs on / type tmpfs'; then
    error_and_exit "Can't run this script in Live OS."
fi

# 不支持容器虚拟化
if is_in_container; then
    error_and_exit "Not Supported OS in Container.\nPlease use https://github.com/LloydAsp/OsMutation"
fi

# 不支持安全启动
if is_secure_boot_enabled; then
    error_and_exit "Please disable secure boot first."
fi

# 整理参数
long_opts=
for o in ci installer debug minimal no-cloud-kernel allow-ping force-cn help \
    add-driver: \
    hold: sleep: \
    iso: \
    image-name: \
    boot-wim: \
    img: \
    cloud-data: \
    lang: \
    user: username: \
    passwd: password: \
    ssh-port: \
    ssh-key: public-key: \
    rdp-port: \
    web-port: http-port: \
    allow-ping: \
    commit: \
    frpc-conf: frpc-config: \
    target-disk: \
    force-boot-mode: \
    force-old-windows-setup:; do
    [ -n "$long_opts" ] && long_opts+=,
    long_opts+=$o
done

# 使用 getopt 解析参数
if ! ORIGINAL_OPTS=$(getopt -n $0 -o "h,x" --long "$long_opts" -- "$@"); then
    exit 1
fi

# 第一遍扫描，验证要安装的系统和版本
eval set -- "$ORIGINAL_OPTS"
while true; do
    case "$1" in
    -x | --debug)
        set -x
        shift
        ;;
    --)
        shift
        verify_os_name "$@"
        break
        ;;
    *)
        shift
        ;;
    esac
done

# 初始化重要变量
# wmic 随时会用到
# wmic 需要下载 wmic.ps1，需要从 confhome 得到，要先将 confhome 改成国内
# 而 wmic.ps1 又放在 $tmp 目录，因此要先创建临时目录
# 处理 --frpc-config 时会下载文件，因此在处理参数前就创建临时目录
mkdir_clear "$tmp"
init_basearch
init_confhome
init_bootloader_facts

if [ "$distro" = reset ]; then
    reset_and_exit
fi

# 安装必备组件
install_pkg curl grep

# 第二遍扫描，处理参数
eval set -- "$ORIGINAL_OPTS"
# shellcheck disable=SC2034
while true; do
    case "$1" in
    -x | --debug)
        # 第一遍扫描已处理
        shift
        ;;
    -h | --help)
        usage_and_exit
        ;;
    --commit)
        commit=$2
        shift 2
        ;;
    --ci)
        cloud_image=1
        unset installer
        shift
        ;;
    --installer)
        installer=1
        unset cloud_image
        shift
        ;;
    --minimal)
        minimal=1
        shift
        ;;
    --no-cloud-kernel)
        no_cloud_kernel=1
        shift
        ;;
    --allow-ping)
        allow_ping=1
        shift
        ;;
    --force-cn)
        # 仅为了方便测试
        force_cn=1
        shift
        ;;
    --hold | --sleep)
        if ! { [ "$2" = 0 ] || [ "$2" = 1 ] || [ "$2" = 2 ]; }; then
            error_and_exit "Invalid $1 value: $2"
        fi
        hold=$2
        shift 2
        ;;
    --frpc-conf | --frpc-config)
        [ -n "$2" ] || error_and_exit "Need value for $1"

        case "$(to_lower <<<"$2")" in
        http://* | https://*)
            frpc_config_url=$2
            frpc_config=$tmp/frpc.conf
            # 用 file 识别文件类型？
            if ! curl -L "$frpc_config_url" -o "$frpc_config"; then
                error_and_exit "Can't get frpc config from $frpc_config_url"
            fi
            ;;
        *)
            # windows 路径转换
            if ! { frpc_config=$(get_unix_path "$2") && [ -f "$frpc_config" ]; }; then
                error_and_exit "File not exists: $2"
            fi
            ;;
        esac

        # 转为绝对路径
        frpc_config=$(readlink -f "$frpc_config")

        shift 2
        ;;
    --force-boot-mode)
        if ! { [ "$2" = bios ] || [ "$2" = efi ]; }; then
            error_and_exit "Invalid $1 value: $2"
        fi
        force_boot_mode=$2
        shift 2
        ;;
    --user | --username)
        [ -n "$2" ] || error_and_exit "Need value for $1"
        username="$(printf "%s" "$2" | trim)"
        assert_username_valid
        shift 2
        ;;
    --passwd | --password)
        [ -n "$2" ] || error_and_exit "Need value for $1"
        password=$2
        shift 2
        ;;
    --ssh-key | --public-key)
        ssh_key_error_and_exit() {
            error "$1"
            cat <<EOF
Available options:
  --ssh-key "ssh-rsa ..."
  --ssh-key "ssh-ed25519 ..."
  --ssh-key "ecdsa-sha2-nistp256/384/521 ..."
  --ssh-key github:your_username
  --ssh-key gitlab:your_username
  --ssh-key http://path/to/public_key
  --ssh-key https://path/to/public_key
  --ssh-key /path/to/public_key
  --ssh-key C:\path\to\public_key
EOF
            exit 1
        }

        # https://manpages.debian.org/testing/openssh-server/authorized_keys.5.en.html#AUTHORIZED_KEYS_FILE_FORMAT
        is_valid_ssh_key() {
            grep -qE '^(ecdsa-sha2-nistp(256|384|521)|ssh-(ed25519|rsa)) ' <<<"$1"
        }

        [ -n "$2" ] || ssh_key_error_and_exit "Need value for $1"

        case "$(to_lower <<<"$2")" in
        gh:* | github:* | gl:* | gitlab:* | http://* | https://*)
            if [[ "$(to_lower <<<"$2")" = http* ]]; then
                key_url=$2
            else
                IFS=: read -r site user <<<"$2"
                case "$(to_lower <<<"$site")" in
                gh | github) site=github ;;
                gl | gitlab) site=gitlab ;;
                *) ;;
                esac
                [ -n "$user" ] || ssh_key_error_and_exit "Need a username for $site"
                key_url="https://$site.com/$user.keys"
            fi
            if ! ssh_key=$(curl -L "$key_url"); then
                error_and_exit "Can't get ssh key from $key_url"
            fi
            ;;
        *)
            # 检测值是否为 ssh key
            if is_valid_ssh_key "$2"; then
                ssh_key=$2
            else
                # 视为路径
                # windows 路径转换
                if ! { ssh_key_file=$(get_unix_path "$2") && [ -f "$ssh_key_file" ]; }; then
                    ssh_key_error_and_exit "SSH Key/File/Url \"$2\" is invalid."
                fi
                ssh_key=$(<"$ssh_key_file")
            fi
            ;;
        esac

        # 检查 key 格式
        if ! is_valid_ssh_key "$ssh_key"; then
            ssh_key_error_and_exit "SSH Key/File/Url \"$2\" is invalid."
        fi

        # 保存 key
        # 不用处理注释，可以支持写入 authorized_keys
        # 安装 nixos 时再处理注释/空行，转成数组，再添加到 nix 配置文件中
        if [ -n "$ssh_keys" ]; then
            ssh_keys+=$'\n'
        fi
        ssh_keys+=$ssh_key

        shift 2
        ;;
    --ssh-port)
        is_port_valid $2 || error_and_exit "Invalid $1 value: $2"
        ssh_port=$2
        shift 2
        ;;
    --rdp-port)
        is_port_valid $2 || error_and_exit "Invalid $1 value: $2"
        rdp_port=$2
        shift 2
        ;;
    --web-port | --http-port)
        is_port_valid $2 || error_and_exit "Invalid $1 value: $2"
        web_port=$2
        shift 2
        ;;
    --add-driver)
        [ -n "$2" ] || error_and_exit "Need value for $1"

        # windows 路径转换
        inf_or_dir=$(get_unix_path "$2")

        # alpine busybox 不支持 readlink -m
        # readlink -m /asfsafasfsaf/fasf
        # 因此需要先判断路径是否存在

        if ! [ -d "$inf_or_dir" ] &&
            ! { [ -f "$inf_or_dir" ] && [[ "$inf_or_dir" =~ \.[iI][nN][fF]$ ]]; }; then
            error_and_exit "Not a inf or dir: $2"
        fi

        # 转为绝对路径
        inf_or_dir=$(readlink -f "$inf_or_dir")

        info "finding inf in $inf_or_dir"
        # find /tmp -type f -iname '*.inf' 只要 /tmp 存在就会返回 0
        if infs=$(find "$inf_or_dir" -type f -iname '*.inf' | grep .); then
            while IFS= read -r inf; do
                # 防止重复添加
                if ! grep -Fqx "$inf" <<<"$custom_infs"; then
                    echo "inf found: $inf"
                    # 一行一个 inf
                    if [ -n "$custom_infs" ]; then
                        custom_infs+=$'\n'
                    fi
                    custom_infs+=$inf
                fi
            done <<<"$infs"
        else
            error_and_exit "Can't find inf files in $2"
        fi

        shift 2
        ;;
    --force-old-windows-setup)
        force_old_windows_setup=$2
        shift 2
        ;;
    --target-disk)
        xda=${2##*/dev/}
        if ! [ -b "/dev/$xda" ]; then
            error_and_exit "Can't not find Disk $2."
        fi
        shift 2
        ;;
    --img)
        img=$2
        shift 2
        ;;
    --cloud-data)
        cloud_data=$2
        shift 2
        ;;
    --iso)
        iso=$2
        shift 2
        ;;
    --boot-wim)
        boot_wim=$2
        shift 2
        ;;
    --image-name)
        image_name=$(echo "$2" | to_lower)
        shift 2
        ;;
    --lang)
        if ! is_valid_lang_chars "$2"; then
            error_and_exit "Invalid $1 value: $2"
        fi
        lang=$(echo "$2" | to_lower)
        shift 2
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Unexpected option: $1."
        usage_and_exit
        ;;
    esac
done

# Fleet: private password file and verified disk, before credential prompts.
fleet_load_inputs

# 检查必须的参数
verify_os_args

# 用户名
if ! is_netboot_xyz && [ -z "$username" ]; then
    prompt_username
fi

# 密码
if ! is_netboot_xyz && [ -z "$ssh_keys" ] && [ -z "$password" ]; then
    if is_use_dd; then
        show_dd_password_tips
    fi
    prompt_password
fi

# 强制忽略/强制添加 --ci 参数
# debian 不强制忽略 ci 留作测试
case "$distro" in
dd | windows | netboot.xyz | kali | alpine | arch | gentoo | aosc | nixos | fnos)
    if is_use_cloud_image; then
        echo "ignored --ci"
        unset cloud_image
    fi
    ;;
oracle | opensuse | anolis | opencloudos | openeuler)
    cloud_image=1
    ;;
redhat | centos | almalinux | rocky | fedora | ubuntu)
    if is_force_use_installer; then
        unset cloud_image
    else
        cloud_image=1
    fi
    ;;
esac

# 检查内存
# 会用到 wmic，因此要在设置国内 confhome 后使用
check_ram

# 以下目标系统不需要两步安装
# alpine
# debian
# el7 x86_64 >=1g
# el7 aarch64 >=1.5g
# el8/9/fedora 任何架构 >=2g
if is_netboot_xyz ||
    { ! is_use_cloud_image && {
        [ "$distro" = "alpine" ] || is_distro_like_debian ||
            { is_distro_like_redhat && [ $releasever -eq 7 ] && [ $ram_size -ge 1024 ] && [ $basearch = "x86_64" ]; } ||
            { is_distro_like_redhat && [ $releasever -eq 7 ] && [ $ram_size -ge 1536 ] && [ $basearch = "aarch64" ]; } ||
            { is_distro_like_redhat && [ $releasever -ge 8 ] && [ $ram_size -ge 2048 ]; }
    }; }; then
    setos nextos $distro $releasever
else
    # alpine 作为中间系统时，使用最新版
    alpine_ver_for_trans=$(get_latest_distro_releasever alpine)
    setos finalos $distro $releasever
    setos nextos alpine $alpine_ver_for_trans
fi

# 有的机器开启了 kexec，例如腾讯云轻量 debian，要禁用
if [ -f /etc/default/kexec ]; then
    sed -i 's/LOAD_KEXEC=true/LOAD_KEXEC=false/' /etc/default/kexec
fi

# 一切就绪，正式下载内核和添加引导项
# 先删除之前的启动项，再设置 trap
# 暂时不用 trap，因为 bat 下无效
remove_exist_reinstall
# trap 'reset_and_exit true' SIGINT

# 下载 netboot.xyz / 内核
# shellcheck disable=SC2154
if is_netboot_xyz; then
    if is_efi; then
        if is_in_windows; then
            add_efi_entry_in_windows $nextos_efi
        else
            add_efi_entry_in_linux $nextos_efi
        fi
    else
        curl -Lo /reinstall-vmlinuz $nextos_vmlinuz
    fi
else
    # 下载 nextos 内核
    info download vmlnuz and initrd
    curl -Lo /reinstall-vmlinuz $nextos_vmlinuz
    curl -Lo /reinstall-initrd $nextos_initrd
    if is_use_firmware; then
        curl -Lo /reinstall-firmware $nextos_firmware
    fi
fi

# 修改 alpine debian kali initrd
if [ "$nextos_distro" = alpine ] || is_distro_like_debian "$nextos_distro"; then
    mod_initrd
fi

# web 路径
if is_need_web_viewer; then
    web_path="/$(tr -dc "A-Za-z0-9" </dev/urandom | head -c8)"
fi

# 将内核/netboot.xyz.lkrn 放到正确的位置
if false && is_need_boot_vmlinuz; then
    if is_in_windows; then
        cp -f /reinstall-vmlinuz /cygdrive/$c/
        is_have_initrd && cp -f /reinstall-initrd /cygdrive/$c/
    else
        if is_os_in_btrfs && is_os_in_subvol; then
            cp_to_btrfs_root /reinstall-vmlinuz
            is_have_initrd && cp_to_btrfs_root /reinstall-initrd
        fi
    fi
fi

# 需要使用 vmlinuz/initrd 引导的情况
if is_need_boot_vmlinuz; then
    # win 使用外部 grub
    if is_in_windows; then
        install_grub_win
    else
        # linux efi 使用外部 grub，因为
        # 1. 原系统 grub 可能没有去除 aarch64 内核 magic number 校验
        # 2. 原系统可能不是用 grub
        if is_efi; then
            install_grub_linux_efi
        fi
    fi

    # 找到 /reinstall-vmlinuz /reinstall-initrd 的绝对路径
    if is_in_windows; then
        # dir=/cygwin/
        dir=$(cygpath -m / | cut -d: -f2-)/
    else
        # extlinux + 单独的 boot 分区
        # 把内核文件放在 extlinux.conf 所在的目录
        if is_use_local_extlinux && is_boot_in_separate_partition; then
            dir=
        else
            # 获取当前系统根目录在 btrfs 中的绝对路径
            if is_os_in_btrfs; then
                # btrfs subvolume show /
                # 输出可能是 / 或 root 或 @/.snapshots/1/snapshot
                dir=$(btrfs subvolume show / | head -1)
                if ! [ "$dir" = / ]; then
                    dir="/$dir/"
                fi
            else
                dir=/
            fi
        fi
    fi

    vmlinuz=${dir}reinstall-vmlinuz
    initrd=${dir}reinstall-initrd
    firmware=${dir}reinstall-firmware

    # 设置 linux initrd 命令
    if is_use_local_extlinux; then
        linux_cmd=LINUX
        initrd_cmd=INITRD
    else
        if is_netboot_xyz; then
            linux_cmd=linux16
            initrd_cmd=initrd16
        else
            linux_cmd=linux
            initrd_cmd=initrd
        fi
    fi

    # 设置 cmdlind initrds
    if ! is_netboot_xyz; then
        find_main_disk
        build_cmdline

        initrds="$initrd"
        if is_use_firmware; then
            initrds+=" $firmware"
        fi
    fi

    if is_use_local_extlinux; then
        info extlinux
        echo "$target_cfg"
        extlinux_dir="$(dirname "$target_cfg")"

        # 不起作用
        # 好像跟 extlinux --once 有冲突
        sed -i "/^MENU HIDDEN/d" "$target_cfg"
        sed -i "/^TIMEOUT /d" "$target_cfg"

        del_empty_lines <<EOF | tee -a "$target_cfg"
$BOOT_ENTEY_START_MARK
TIMEOUT 5
LABEL reinstall
  MENU LABEL $(get_entry_name)
  $linux_cmd $vmlinuz
  $([ -n "$initrds" ] && echo "$initrd_cmd $initrds")
  $([ -n "$cmdline" ] && echo "APPEND $cmdline")
$BOOT_ENTEY_END_MARK
EOF
        # 设置重启引导项
        extlinux --once=reinstall $extlinux_dir

        # 复制文件到 extlinux 工作目录
        if is_boot_in_separate_partition; then
            info "copying files to $extlinux_dir"
            is_have_initrd && cp -f /reinstall-initrd $extlinux_dir
            is_use_firmware && cp -f /reinstall-firmware $extlinux_dir
            # 放最后，防止前两条返回非 0 而报错
            cp -f /reinstall-vmlinuz $extlinux_dir
        fi
    else
        # cloudcone 从光驱的 grub 启动，再加载硬盘的 grub.cfg
        # menuentry "Grub 2" --id grub2 {
        #         set root=(hd0,msdos1)
        #         configfile /boot/grub2/grub.cfg
        # }

        # 加载后 $prefix 依然是光驱的 (hd96)/boot/grub
        # 导致找不到 $prefix 目录的 grubenv，因此读取不到 next_entry
        # 以下方法为 cloudcone 重新加载 grubenv

        # 需查找 2*2 个文件夹
        # 分区：系统 / boot
        # 文件夹：grub / grub2
        # shellcheck disable=SC2121,SC2154
        # cloudcone debian 能用但 ubuntu 模板用不了
        # ubuntu 模板甚至没显示 reinstall menuentry
        load_grubenv_if_not_loaded() {
            if ! [ -s $prefix/grubenv ]; then
                for dir in /boot/grub /boot/grub2 /grub /grub2; do
                    set grubenv="($root)$dir/grubenv"
                    if [ -s $grubenv ]; then
                        load_env --file $grubenv
                        if [ "${next_entry}" ]; then
                            set default="${next_entry}"
                            set next_entry=
                            save_env --file $grubenv next_entry
                        else
                            set default="0"
                        fi
                        return
                    fi
                done
            fi
        }

        # 生成 grub 配置
        # 实测 centos 7 lvm 要手动加载 lvm 模块
        info grub
        echo $target_cfg

        echo '### BEGIN reinstall.sh ###' >$target_cfg

        get_function_content load_grubenv_if_not_loaded >>$target_cfg

        # 原系统为 openeuler 云镜像，需要添加 --unrestricted，否则要输入密码
        del_empty_lines <<EOF | del_comment_lines | tee -a $target_cfg
set timeout_style=menu
set timeout=5
menuentry "$(get_entry_name)" --unrestricted {
    $(! is_in_windows && echo 'insmod lvm')
    $(is_os_in_btrfs && echo 'set btrfs_relative_path=n')
    # fedora efi 没有 load_video
    insmod all_video
    # set gfxmode=800x600
    # set gfxpayload=keep
    # terminal_output gfxterm 在 vultr 上会花屏
    # terminal_output console
    search --no-floppy --file --set=root $vmlinuz
    $linux_cmd $vmlinuz $cmdline
    $([ -n "$initrds" ] && echo "$initrd_cmd $initrds")
}
EOF
        echo '### END reinstall.sh ###' >>$target_cfg

        # 设置重启引导项
        if is_use_local_grub; then
            $grub-reboot "$(get_entry_name)"
        fi
    fi
fi

info 'info'
echo "$distro $releasever"

ssh_port=${ssh_port:-22}
rdp_port=${rdp_port:-3389}
web_port=${web_port:-80}

if [ "$distro" = netboot.xyz ]; then
    :
elif [ "$distro" = alpine ] && [ "$hold" = 1 ]; then
    info "Alpine Live OS"
    echo "Username: $username"
    if [ -n "$ssh_keys" ]; then
        echo "Public Key: $ssh_keys"
    else
        echo "Password: $password"
    fi
    echo "SSH Port: $ssh_port"

elif [ "$distro" = fnos ]; then
    info "While Install (View Logs)"
    echo "Username: $username"
    if [ -n "$ssh_keys" ]; then
        echo "Public Key: $ssh_keys"
    else
        echo "Password: $password"
    fi
    echo "SSH Port: $ssh_port"
    echo "WEB: $(get_http_log_url)"

    info "After Install"

    echo "安装后不会开启 SSH 服务。"
    echo "你需要尽快到 http://IP:5666 配置账号密码。"
    echo
    echo "SSH Service is disabled after installation."
    echo "You need to config the username and password on http://IP:5666 as soon as possible."

elif [ "$distro" = windows ]; then
    info "While Install (View Logs)"
    echo "Username: $username"
    echo "Password: $password"
    echo "SSH Port: $ssh_port"
    echo "WEB: $(get_http_log_url)"

    info "After Install"
    if is_administrator_username "$username"; then
        echo "Username: $username (Depends on Windows iso's language)"
    else
        echo "Username: $username"
    fi
    echo "Password: $password"
    echo "RDP Port: $rdp_port"

elif [ "$distro" = dd ]; then
    info "While Install (View Logs)"
    echo "Username: $username"
    if [ -n "$ssh_keys" ]; then
        echo "Public Key: $ssh_keys"
    else
        echo "Password: $password"
    fi
    echo "SSH Port: $ssh_port"
    echo "WEB: $(get_http_log_url)"

    info "After Install"
    if [ -n "$cloud_data" ]; then
        echo "Cloud Data: $cloud_data"
        echo "Cloud Data Files: $cloud_data_files"
    else
        echo "Username: [Depends on image]"
        echo "Public Key: [Depends on image]"
        echo "Password: [Depends on image]"
        echo "SSH Port: [Depends on image]"
    fi

else
    # 普通 linux
    info "While Install (View Logs)"
    echo "Username: $username"
    if [ -n "$ssh_keys" ]; then
        echo "Public Key: $ssh_keys"
    else
        echo "Password: $password"
    fi
    echo "SSH Port: $ssh_port"
    echo "WEB: $(get_http_log_url)"

    info "After Install"
    echo "Username: $username"
    if [ -n "$ssh_keys" ]; then
        echo "Public Key: $ssh_keys"
    else
        echo "Password: $password"
    fi
    echo "SSH Port: $ssh_port"
fi

if is_in_windows; then
    echo
    echo 'You can run this command to reboot:'
    echo 'shutdown /r /t 0'
fi

echo
if [ "$distro" = netboot.xyz ]; then
    echo '重启后进入 netboot.xyz。'
    echo "或者现在运行 \"$reinstall_____ reset\" 以清除该引导项。"
    echo
    echo 'Reboot to start netboot.xyz.'
    echo "Or run \"$reinstall_____ reset\" now to clear this boot entry."
    echo

elif [ "$distro" = alpine ] && [ "$hold" = 1 ]; then
    echo '重启后进入 Alpine Live OS。'
    echo "或者现在运行 \"$reinstall_____ reset\" 以清除该引导项。"
    echo
    echo 'Reboot to start Alpine Live OS.'
    echo "Or run \"$reinstall_____ reset\" now to clear this boot entry."
    echo
else
    warn false '警告：重装会清除主硬盘的所有数据，包括所有分区！'
    echo '重启后开始重装。'
    echo "或者现在运行 \"$reinstall_____ reset\" 以取消重装。"
    echo
    warn false 'Warning: Reinstalling will erase all data on the main disk, including all partitions!'
    echo 'Reboot to start the reinstallation.'
    echo "Or run \"$reinstall_____ reset\" now to cancel the reinstallation."
fi
echo
FILE_50e8307af9bfd30c

# vendor/trans.sh
cat >"$FLEET_UNPACK/vendor/trans.sh" <<'FILE_67929f6610795837'
#!/bin/ash
# shellcheck shell=dash
# shellcheck disable=SC2086,SC3047,SC3036,SC3010,SC3001,SC3060,SC3015
# alpine 默认使用 busybox ash
# 注意 bash 和 ash 以下语句结果不同
# [[ a = '*a' ]] && echo 1

# 出错后停止运行，将进入到登录界面，防止失联
set -eE

# 用于判断 reinstall.sh 和 trans.sh 是否兼容
# shellcheck disable=SC2034
SCRIPT_VERSION=4BACD833-A585-23BA-6CBB-9AA4E08E0004

TRUE=0
FALSE=1
EFI_UUID=C12A7328-F81F-11D2-BA4B-00A0C93EC93B

error() {
    color='\e[31m'
    plain='\e[0m'
    echo -e "${color}***** ERROR *****${plain}" >&2
    echo -e "${color}$*${plain}" >&2
}

info() {
    color='\e[32m'
    plain='\e[0m'
    local msg

    if [ "$1" = false ]; then
        shift
        msg=$*
    else
        msg=$(echo "$*" | to_upper)
    fi

    echo -e "${color}***** $msg *****${plain}" >&2
}

warn() {
    color='\e[33m'
    plain='\e[0m'
    echo -e "${color}Warning: $*${plain}" >&2
}

error_and_exit() {
    error "$@"

    if is_have_cmd sudo; then
        sudo_='sudo '
    elif is_have_cmd doas; then
        sudo_='doas '
    else
        sudo_=
    fi

    echo "Run '$sudo_/trans.sh' to retry." >&2
    echo "Run '$sudo_/trans.sh alpine' to install Alpine Linux instead." >&2

    # 解除锁定，允许用户登录处理故障
    # passwd -u "$username" >/dev/null

    # 用不着，因为 alpine 锁定账户后无法登录 ssh
    # 因此不会锁定

    exit 1
}

trap_err() {
    line_no=$1
    ret_no=$2

    error_and_exit "$(
        echo "Line $line_no return $ret_no"
        if [ -f "/trans.sh" ]; then
            sed -n "$line_no"p /trans.sh
        fi
    )"
}

is_run_from_locald() {
    [[ "$0" = "/etc/local.d/*" ]]
}

# reinstall.sh 有相同方法 add_community_repo_for_alpine
add_community_repo() {
    local ver mirror

    # 先检查原来的 repo 是不是 edge 或者 latest-stable
    if grep -q "^http.*/edge/main$" /etc/apk/repositories; then
        ver=edge
    elif grep -q "^http.*/latest-stable/main$" /etc/apk/repositories; then
        ver=latest-stable
    else
        ver=v$(cut -d. -f1,2 </etc/alpine-release)
    fi

    if ! grep -q "^http.*/$ver/community$" /etc/apk/repositories; then
        mirror=$(grep '^http.*/main$' /etc/apk/repositories | sed 's,/[^/]*/main$,,' | head -1)
        echo $mirror/$ver/community >>/etc/apk/repositories
    fi
}

# 有时网络问题下载失败，导致脚本中断
# 因此需要重试
apk() {
    retry 5 command apk "$@" >&2
}

show_url_in_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
        [Hh][Tt][Tt][Pp][Ss]://* | [Hh][Tt][Tt][Pp]://* | [Mm][Aa][Gg][Nn][Ee][Tt]:*) echo "$1" ;;
        esac
        shift
    done
}

killall() {
    # killall 是异步的，要等一下
    local ret=0
    if ! command killall "$@"; then
        ret=$?
    fi
    sleep 5
    return $ret
}

# 在没有设置 set +o pipefail 的情况下，限制下载大小：
# retry 5 command wget | head -c 1048576 会触发 retry，下载 5 次
# command wget "$@" --tries=5 | head -c 1048576 不会触发 wget 自带的 retry，只下载 1 次
wget() {
    show_url_in_args "$@" >&2
    if command wget 2>&1 | grep -q BusyBox; then
        # busybox wget 没有重试功能
        # 好像默认永不超时
        retry 5 command wget "$@" -T 10
    else
        # 原版 wget 自带重试功能
        command wget --tries=5 --progress=bar:force "$@"
    fi
}

is_have_cmd() {
    # command -v 包括脚本里面的方法
    is_have_cmd_on_disk / "$1"
}

is_have_cmd_on_disk() {
    local os_dir=$1
    local cmd=$2

    for bin_dir in /bin /sbin /usr/bin /usr/sbin; do
        if [ -f "$os_dir$bin_dir/$cmd" ]; then
            return
        fi
    done
    return 1
}

is_num() {
    echo "$1" | grep -Exq '[0-9]*\.?[0-9]*'
}

retry() {
    local max_try=$1
    shift

    if is_num "$1"; then
        local interval=$1
        shift
    else
        local interval=5
    fi

    local i
    for i in $(seq $max_try); do
        if "$@"; then
            return
        else
            ret=$?
            # wget -O- | grep -m1 成功后会提前关闭管道，导致 141 错误
            # 这是预期行为，因此需要排除
            if [ $ret -eq 141 ]; then
                return
            fi
            if [ $i -ge $max_try ]; then
                return $ret
            fi
            sleep $interval
        fi
    done
}

get_url_type() {
    if [[ "$1" = magnet:* ]]; then
        echo bt
    else
        echo http
    fi
}

is_magnet_link() {
    [[ "$1" = magnet:* ]]
}

create_alpine_rootfs() {
    local os_dir=$1
    local init_now=${2:-false}

    # 复制当前系统的 /etc/apk 文件夹
    mkdir -p "$os_dir"
    cp -a --parents /etc/apk "$os_dir"
    rm -f "$os_dir/etc/apk/world"

    # 安装 alpine
    apk add --root "$os_dir" --initdb \
        alpine-base openssl ca-certificates

    if $init_now; then
        cp_resolv_conf "$os_dir"
        mount_pseudo_fs "$os_dir"
    fi
}

create_alpine_rootfs_with_arch_install_scripts() {
    local os_dir=$1
    local init_now=${2:-false}
    local parent_os_dir=$3

    create_alpine_rootfs "$os_dir" $init_now

    # 将 alpine-base 的依赖写入 world，再删除 alpine-base alpine-conf
    # --installed --depends 顺序不能错
    # 不添加 --installed 则会同时显示已安装的和最新版的
    alpine_base_depends=$(chroot "$os_dir" apk info --installed --depends alpine-base | sed '/depends on:/d')
    chroot "$os_dir" apk add $alpine_base_depends
    chroot "$os_dir" apk del alpine-base alpine-conf
    chroot "$os_dir" apk add arch-install-scripts

    if [ -n "$parent_os_dir" ]; then
        mkdir -p "$os_dir/parent"
        mount --rbind "$parent_os_dir" "$os_dir/parent"
    fi
}

remove_alpine_rootfs() {
    local os_dir=$1

    umount_pseudo_fs "$os_dir"
    rm -rf "$os_dir"
}

download_via_browser() {
    local url=$1
    local path=$2

    local os_dir=/os/alpine_for_browser
    mkdir_clear "$os_dir"

    # 安装 chromium-headless-shell npm 到硬盘，减少内存占用
    create_alpine_rootfs "$os_dir" true
    apk add --root "$os_dir" chromium-headless-shell npm

    # 添加 swap
    # 否则 512M 内存会报错 browserContext.newPage: Target crashed
    local swapfile=$os_dir/swapfile
    create_swap_if_ram_less_than 1024 "$swapfile"

    # 安装 playwright
    # shellcheck disable=SC2046
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 \
        chroot "$os_dir" \
        npm install \
        --no-save --no-package-lock \
        --prefix "/work" \
        $(is_in_china && echo '--registry=https://registry.npmmirror.com') \
        playwright

    # 下载文件
    # shellcheck disable=SC2154
    wget "$confhome/download-via-browser.js" -O "$os_dir/work/download-via-browser.js"
    retry 5 chroot "$os_dir" node /work/download-via-browser.js "$url" "/work/download_file"
    cp "$os_dir/work/download_file" "$path"

    # 删除 swap
    if [ -f "$swapfile" ]; then
        swapoff "$swapfile"
        rm -f "$swapfile"
    fi

    # 清理
    remove_alpine_rootfs "$os_dir"
}

download() {
    local url=$1
    local path=$2
    local can_use_cn_mirror=${3:-false}

    # 有ipv4地址无ipv4网关的情况下，aria2可能会用ipv4下载，而不是ipv6
    # axel 在 lightsail 上会占用大量cpu
    # https://download.opensuse.org/distribution/leap/15.5/appliances/openSUSE-Leap-15.5-Minimal-VM.x86_64-kvm-and-xen.qcow2
    # https://aria2.github.io/manual/en/html/aria2c.html#cmdoption-o

    # 阿里云源限速，而且检测 user-agent 禁止 axel/aria2 下载
    # aria2 默认 --max-tries 5

    # 默认 --max-tries=5，但以下情况服务器出错，aria2不会重试，而是直接返回错误
    # 因此添加 for 循环
    #     [ERROR] CUID#7 - Download aborted. URI=https://aka.ms/manawindowsdrivers
    # Exception: [AbstractCommand.cc:351] errorCode=1 URI=https://aka.ms/manawindowsdrivers
    #   -> [SocketCore.cc:1019] errorCode=1 SSL/TLS handshake failure:  `not signed by known authorities or invalid'

    # 用 if 的话，报错不会中断脚本
    # if aria2c xxx; then
    #     return
    # fi

    # --user-agent=Wget/1.21.1 \
    # --retry-wait 5

    # 检测大小时已经下载了种子
    if [ "$(get_url_type "$url")" = bt ]; then
        torrent="$(get_torrent_path_by_magnet $url)"
        if ! [ -f "$torrent" ]; then
            download_torrent_by_magnet "$url" "$torrent"
        fi
        url=$torrent
    fi

    # intel 禁止了 aria2 下载驱动
    # intel 禁止了 wget 下载网页内容
    # 腾讯云 virtio 驱动也禁止了 aria2 下载

    # -o 设置 http 下载文件名
    # -O 设置 bt 首个文件的文件名
    set -- \
        -d "$(dirname "$path")" \
        -o "$(basename "$path")" \
        -O "1=$(basename "$path")" \
        -U curl/7.54.1

    if ! aria2c "$url" "$@" &&
        ! { $can_use_cn_mirror && is_in_china && is_any_ipv4_has_internet &&
            url_cn=https://files.m.daocloud.io/$(echo "$url" | sed -E 's,^https?://,,i') &&
            aria2c "$url_cn" "$@"; }; then
        error_and_exit "Failed to download $url"
    fi

    # opensuse 官方镜像支持 metalink
    # aria2 无法重命名用 metalink 下载的文件
    # 需用以下方法重命名
    if head -c 1024 "$path" | grep -Fq 'urn:ietf:params:xml:ns:metalink'; then
        real_file=$(tr -d '\n' <"$path" | sed -E 's|.*<file[[:space:]]+name="([^"]*)".*|\1|')
        mv "$(dirname "$path")/$real_file" "$path"
    fi
}

update_part() {
    sleep 1
    sync
    sleep 1

    # partprobe
    # 有分区挂载中会报 Resource busy 错误
    if is_have_cmd partprobe; then
        partprobe /dev/$xda 2>/dev/null || true
        sleep 1
    fi

    # partx
    # https://access.redhat.com/solutions/199573
    if is_have_cmd partx; then
        partx -u /dev/$xda
        sleep 1
    fi

    # mdev
    # mdev 不会删除 /dev/disk/ 的旧分区，因此手动删除
    # 如果 rm -rf 的时候刚好 mdev 在创建链接，rm -rf 会报错 Directory not empty
    # 因此要先停止 mdev 服务
    # 还要删除 /dev/$xda*?
    ensure_service_stopped mdev
    sleep 1
    # 即使停止了 mdev，有时也会报 Directory not empty，因此添加 retry
    retry 5 rm -rf /dev/disk/*

    # 没挂载 modloop 时会提示
    # modprobe: can't change directory to '/lib/modules': No such file or directory
    # 因此强制不显示上面的提示
    mdev -sf 2>/dev/null
    sleep 1
    ensure_service_started mdev 2>/dev/null
    sleep 1
}

is_efi() {
    if [ -n "$force_boot_mode" ]; then
        [ "$force_boot_mode" = efi ]
    else
        [ -d /sys/firmware/efi/ ]
    fi
}

is_use_cloud_image() {
    [ -n "$cloud_image" ] && [ "$cloud_image" = 1 ]
}

is_allow_ping() {
    [ -n "$allow_ping" ] && [ "$allow_ping" = 1 ]
}

setup_nginx() {
    apk add nginx
    # shellcheck disable=SC2154
    wget $confhome/logviewer.html -O /logviewer.html
    wget $confhome/logviewer-nginx.conf -O /etc/nginx/http.d/default.conf

    sed -i "s/@WEB_PORT@/$web_port/gi" /etc/nginx/http.d/default.conf

    # rc-service -q nginx start
    if pgrep nginx >/dev/null; then
        nginx -s reload
    else
        nginx
    fi
}

setup_websocketd() {
    apk add websocketd
    apk add coreutils

    mkdir -p /tmp/web
    echo 'Wrong Path' >/tmp/web/index.html
    # shellcheck disable=SC2154
    wget $confhome/logviewer.html -O /tmp/web$web_path

    killall -q websocketd || true
    # websocketd 遇到 \n 才推送，因此要转换 \r 为 \n
    websocketd --port "$web_port" --loglevel=fatal --staticdir=/tmp/web \
        stdbuf -oL -eL \
        sh -c "if [ \"\$PATH_INFO\" = \"$web_path\" ]; then tail -fn+0 /reinstall.log | tr '\r' '\n' | grep -Fiv -e password -e token; fi" &
}

get_approximate_ram_size() {
    # lsmem 需要 util-linux
    if false && is_have_cmd lsmem; then
        ram_size=$(lsmem -b 2>/dev/null | grep 'Total online memory:' | awk '{ print $NF/1024/1024 }')
    fi

    if [ -z $ram_size ]; then
        ram_size=$(free -m | awk '{print $2}' | sed -n '2p')
    fi

    echo "$ram_size"
}

setup_web_if_enough_ram() {
    total_ram=$(get_approximate_ram_size)
    # 512内存才安装
    if [ "$total_ram" -ge 400 ]; then
        # lighttpd 虽然运行占用内存少，但安装占用空间大
        # setup_lighttpd
        # setup_nginx
        setup_websocketd
    fi
}

setup_lighttpd() {
    apk add lighttpd
    ln -sf /reinstall.html /var/www/localhost/htdocs/index.html
    rc-service -q lighttpd start
}

get_ttys() {
    prefix=$1
    # shellcheck disable=SC2154
    wget $confhome/ttys.sh -O- | sh -s $prefix
}

find_xda() {
    # 出错后再运行脚本，硬盘可能已经格式化，之前记录的分区表 id 无效
    # 因此找到 xda 后要保存 xda 到 /configs/xda

    # 先读取之前保存的
    if xda=$(get_config xda 2>/dev/null) && [ -n "$xda" ]; then
        return
    fi

    # 防止 $main_disk 为空
    if [ -z "$main_disk" ]; then
        error_and_exit "cmdline main_disk is empty."
    fi

    # busybox fdisk/lsblk/blkid 不显示 mbr 分区表 id
    # 可用以下工具：
    # fdisk 在 util-linux-misc 里面，占用大
    # sfdisk 占用小
    # lsblk
    # blkid

    tool=sfdisk

    is_have_cmd $tool && need_install_tool=false || need_install_tool=true
    if $need_install_tool; then
        apk add $tool
    fi

    if [ "$tool" = sfdisk ]; then
        # sfdisk
        for disk in $(get_all_disks); do
            if sfdisk --disk-id "/dev/$disk" | sed 's/0x//' | grep -ix "$main_disk"; then
                xda=$disk
                break
            fi
        done
    else
        # lsblk
        xda=$(lsblk --nodeps -rno NAME,PTUUID | grep -iw "$main_disk" | awk '{print $1}')
    fi

    if [ -n "$xda" ]; then
        set_config xda "$xda"
    else
        error_and_exit "Could not find xda: $main_disk"
    fi

    if $need_install_tool; then
        apk del $tool
    fi
}

get_all_disks() {
    # shellcheck disable=SC2010
    ls /sys/block/ | grep -Ev '^(loop|sr|nbd)'
}

extract_env_from_cmdline() {
    # 提取 finalos/extra 到变量
    for prefix in finalos extra; do
        while read -r line; do
            if [ -n "$line" ]; then
                key=$(echo $line | cut -d= -f1)
                value=$(echo $line | cut -d= -f2-)
                eval "$key='$value'"
            fi
        done < <(xargs -n1 </proc/cmdline | grep "^${prefix}_" | sed "s/^${prefix}_//")
    done

    # 如果空白则设置默认值
    if [ "$distro" = windows ]; then
        username=${username:-administrator}
    else
        username=${username:-root}
    fi
    ssh_port=${ssh_port:-22}
    rdp_port=${rdp_port:-3389}
    web_port=${web_port:-80}
}

ensure_service_started() {
    local service=$1

    if ! rc-service -q "$service" start; then
        for i in $(seq 10); do
            if [ "$service" = modloop ]; then
                # 避免有时 modloop 下载不完整导致报错
                # * Failed to verify signature of !
                # mount: mounting /dev/loop0 on /.modloop failed: Invalid argument
                rm -f /lib/modloop-lts /lib/modloop-virt
            fi
            if rc-service -q "$service" start; then
                return
            fi
            sleep 5
        done
        error_and_exit "Failed to start $service."
    fi
}

ensure_service_stopped() {
    local service=$1

    if ! retry 10 5 rc-service -q "$service" stop; then
        error_and_exit "Failed to stop $service."
    fi
}

mod_motd() {
    # 安装后 alpine 后要恢复默认
    # 自动安装失败后，可能手动安装 alpine，因此无需判断 $distro
    file=/etc/motd
    if ! [ -e $file.orig ]; then
        cp $file $file.orig
        # shellcheck disable=SC2016
        echo "mv "\$mnt$file.orig" "\$mnt$file"" |
            insert_into_file "$(which setup-disk)" before 'cleanup_chroot_mounts "\$mnt"'

        cat <<EOF >$file
Reinstalling...
To view logs run:
tail -fn+1 /reinstall.log
EOF
    fi
}

umount_all() {
    dirs="/mnt /os /iso /wim /wim-tmp /installer /nbd /nbd-boot /nbd-efi /nbd-test /root /nix"
    regex=$(echo "$dirs" | sed 's, ,|,g')
    if mounts=$(mount | grep -Ew "on $regex" | awk '{print $3}' | tac); then
        for mount in $mounts; do
            echo "umount $mount"
            umount $mount
        done
    fi
}

# 可能脚本不是首次运行，先清理之前的残留
clear_previous() {
    if is_have_cmd vgchange; then
        umount -R /os /nbd || true
        vgchange -an
        apk add device-mapper
        dmsetup remove_all
    fi
    disconnect_qcow
    # 安装 arch 有 gpg-agent 进程驻留
    # 在 aria2c 下载时手动中止脚本，aria2c 还会在后台下载
    killall -q gpg-agent aria2c || true
    rc-service -q --ifexists --ifstarted nix-daemon stop
    swapoff -a
    umount_all

    # 以下情况 umount -R /1 会提示 busy
    # mount /file1 /1
    # mount /1/file2 /2
}

# virt-what 自动安装 dmidecode，因此同时缓存
cache_dmi_and_virt() {
    if ! [ "$_dmi_and_virt_cached" = 1 ]; then
        apk add virt-what

        # 区分 kvm 和 virtio，原因:
        # 1. 阿里云 c8y virt-what 不显示 kvm
        # 2. 不是所有 kvm 都需要 virtio 驱动，例如 aws nitro
        # 3. virt-what 不会检测 virtio
        _virt=$(
            virt-what

            # hyper-v 环境下 modprobe virtio_scsi 也会创建 /sys/bus/virtio/drivers/virtio_scsi
            # 因此用 devices 判断更准确，有设备时才有 /sys/bus/virtio/drivers/*
            # 或者加上 lspci 检测?

            # 不要用 ls /sys/bus/virtio/devices/* && echo virtio
            # 因为有可能返回值不为 0 而中断脚本
            if ls /sys/bus/virtio/devices/* >/dev/null 2>&1; then
                echo virtio
            fi
        )

        _dmi=$(dmidecode | grep -E '(Manufacturer|Asset Tag|Vendor): ' | awk -F': ' '{print $2}')
        _dmi_and_virt_cached=1
        apk del virt-what
    fi
}

is_virt() {
    cache_dmi_and_virt
    [ -n "$_virt" ]
}

is_virt_contains() {
    cache_dmi_and_virt
    echo "$_virt" | grep -Eiwq "$1"
}

is_dmi_contains() {
    cache_dmi_and_virt
    echo "$_dmi" | grep -Eiwq "$1"
}

cache_lspci() {
    if [ -z "$_lspci" ]; then
        apk add pciutils
        _lspci=$(lspci)
        apk del pciutils
    fi
}

is_lspci_contains() {
    cache_lspci
    echo "$_lspci" | grep -Eiwq "$1"
}

get_config() {
    cat "/configs/$1"
}

set_config() {
    printf '%s' "$2" >"/configs/$1"
}

# ubuntu 安装版、el/ol 安装版不使用该密码
get_password_linux_sha512() {
    get_config password-linux-sha512
}

get_password_windows_administrator_base64() {
    get_config password-windows-administrator-base64
}

get_password_windows_user_base64() {
    get_config password-windows-user-base64
}

get_password_plaintext() {
    get_config password-plaintext
}

is_password_plaintext() {
    get_password_plaintext >/dev/null 2>&1
}

show_netconf() {
    grep -r . /dev/netconf/
}

get_ra_to() {
    if [ -z "$_ra" ]; then
        apk add ndisc6
        # 有时会重复收取，所以设置收一份后退出
        echo "Gathering network info..."
        # shellcheck disable=SC2154
        _ra="$(rdisc6 -1 "$ethx")"
        apk del ndisc6

        # 显示网络配置
        info "Network info:"
        echo
        echo "$_ra" | cat -n
        echo
        ip addr | cat -n
        echo
        show_netconf | cat -n
        echo
    fi
    eval "$1='$_ra'"
}

get_netconf_to() {
    case "$1" in
    slaac | dhcpv6 | rdnss | other) get_ra_to ra ;;
    esac

    # shellcheck disable=SC2154
    # debian initrd 没有 xargs
    case "$1" in
    slaac) echo "$ra" | grep 'Autonomous address conf' | grep -q Yes && res=1 || res=0 ;;
    dhcpv6) echo "$ra" | grep 'Stateful address conf' | grep -q Yes && res=1 || res=0 ;;
    rdnss) res=$(echo "$ra" | grep 'Recursive DNS server' | cut -d: -f2-) ;;
    other) echo "$ra" | grep 'Stateful other conf' | grep -q Yes && res=1 || res=0 ;;
    *) res=$(cat /dev/netconf/$ethx/$1) ;;
    esac

    eval "$1='$res'"
}

is_any_ipv4_has_internet() {
    grep -q 1 /dev/netconf/*/ipv4_has_internet
}

is_in_china() {
    grep -q 1 /dev/netconf/*/is_in_china
}

# 有 dhcpv4 不等于有网关，例如 vultr 纯 ipv6
# 没有 dhcpv4 不等于是静态ip，可能是没有 ip
is_dhcpv4() {
    if ! is_ipv4_has_internet || should_disable_dhcpv4; then
        return 1
    fi

    get_netconf_to dhcpv4
    # shellcheck disable=SC2154
    [ "$dhcpv4" = 1 ]
}

is_staticv4() {
    if ! is_ipv4_has_internet; then
        return 1
    fi

    if ! is_dhcpv4; then
        get_netconf_to ipv4_addr
        get_netconf_to ipv4_gateway
        if [ -n "$ipv4_addr" ] && [ -n "$ipv4_gateway" ]; then
            return 0
        fi
    fi
    return 1
}

is_staticv6() {
    if ! is_ipv6_has_internet; then
        return 1
    fi

    if ! is_slaac && ! is_dhcpv6; then
        get_netconf_to ipv6_addr
        get_netconf_to ipv6_gateway
        if [ -n "$ipv6_addr" ] && [ -n "$ipv6_gateway" ]; then
            return 0
        fi
    fi
    return 1
}

is_dhcpv6_or_slaac() {
    get_netconf_to dhcpv6_or_slaac
    # shellcheck disable=SC2154
    [ "$dhcpv6_or_slaac" = 1 ]
}

is_ipv4_has_internet() {
    get_netconf_to ipv4_has_internet
    # shellcheck disable=SC2154
    [ "$ipv4_has_internet" = 1 ]
}

is_ipv6_has_internet() {
    get_netconf_to ipv6_has_internet
    # shellcheck disable=SC2154
    [ "$ipv6_has_internet" = 1 ]
}

should_disable_dhcpv4() {
    get_netconf_to should_disable_dhcpv4
    # shellcheck disable=SC2154
    [ "$should_disable_dhcpv4" = 1 ]
}

should_disable_accept_ra() {
    get_netconf_to should_disable_accept_ra
    # shellcheck disable=SC2154
    [ "$should_disable_accept_ra" = 1 ]
}

should_disable_autoconf() {
    get_netconf_to should_disable_autoconf
    # shellcheck disable=SC2154
    [ "$should_disable_autoconf" = 1 ]
}

is_slaac() {
    # 如果是静态（包括自动获取到 IP 但无法联网而切换成静态）直接返回 1，不考虑 ra
    # 防止部分机器slaac/dhcpv6获取的ip/网关无法上网

    # 有可能 ra 的 dhcpv6/slaac 是打开的，但实测无法获取到 ipv6 地址
    # is_dhcpv6_or_slaac 是实测结果，因此如果实测不通过，也返回 1

    # 不要判断 is_staticv6，因为这会导致死循环
    if ! is_ipv6_has_internet || ! is_dhcpv6_or_slaac || should_disable_accept_ra || should_disable_autoconf; then
        return 1
    fi
    get_netconf_to slaac
    # shellcheck disable=SC2154
    [ "$slaac" = 1 ]
}

is_dhcpv6() {
    # 如果是静态（包括自动获取到 IP 但无法联网而切换成静态）直接返回 1，不考虑 ra
    # 防止部分机器slaac/dhcpv6获取的ip/网关无法上网

    # 有可能 ra 的 dhcpv6/slaac 是打开的，但实测无法获取到 ipv6 地址
    # is_dhcpv6_or_slaac 是实测结果，因此如果实测不通过，也返回 1

    # 不要判断 is_staticv6，因为这会导致死循环
    if ! is_ipv6_has_internet || ! is_dhcpv6_or_slaac || should_disable_accept_ra || should_disable_autoconf; then
        return 1
    fi
    get_netconf_to dhcpv6

    # shellcheck disable=SC2154
    # 甲骨文即使没有添加 IPv6 地址，RA DHCPv6 标志也是开的
    # 部分系统开机需要等 DHCPv6 超时
    # 这种情况需要禁用 DHCPv6
    if [ "$dhcpv6" = 1 ] && ! ip -6 -o addr show scope global dev "$ethx" | grep -q .; then
        echo 'DHCPv6 flag is on, but DHCPv6 is not working.'
        return 1
    fi

    [ "$dhcpv6" = 1 ]
}

is_have_ipv6() {
    is_slaac || is_dhcpv6 || is_staticv6
}

is_enable_other_flag() {
    get_netconf_to other
    # shellcheck disable=SC2154
    [ "$other" = 1 ]
}

is_have_rdnss() {
    # rdnss 可能有几个
    get_netconf_to rdnss
    [ -n "$rdnss" ]
}

# dd 完检测到镜像是 windows 时会改写此方法
is_windows() {
    [ "$distro" = windows ]
}

# 15063 或之后才支持 rdnss
is_windows_support_rdnss() {
    [ "$build_ver" -ge 15063 ]
}

get_windows_version_from_windows_drive() {
    local os_dir=$1

    # https://wiki.tcl-lang.org/page/Windows+OS+name
    # https://nsis.sourceforge.io/Get_Windows_version

    # win10+ 才有 CurrentMajorVersionNumber 和 CurrentMinorVersionNumber
    # CurrentVersion            6.3
    # CurrentMajorVersionNumber  10
    # CurrentMinorVersionNumber   0

    apk add hivex-perl
    hive=$(find_file_ignore_case $os_dir/Windows/System32/config/SOFTWARE)

    get_current_version_key() {
        hivexget "$hive" "Microsoft\Windows NT\CurrentVersion" "$1"
    }

    # nt_ver
    if { nt_ver_major=$(get_current_version_key CurrentMajorVersionNumber) &&
        nt_ver_minor=$(get_current_version_key CurrentMinorVersionNumber); } 2>/dev/null; then
        nt_ver="$nt_ver_major.$nt_ver_minor"
    else
        # en_windows_vista_sp2_x64_dvd_342267.iso
        # 安装前 CurrentVersion 是 6.0
        # 安装后 CurrentVersion 是 6.0

        # en_windows_vista_sp2_with_update_6003.23713_aio_7in1_x64_v26.01.13_by_adguard.iso
        # 安装前 CurrentVersion 是 6.0.6002.18005
        # 安装后 CurrentVersion 是 6.0

        # 添加 cut 用于兼容这两种情况
        nt_ver=$(get_current_version_key CurrentVersion | cut -d. -f1-2)
    fi

    # build_ver
    # win10 22h2 19045 的 exe/dll 版本还是 19041 的，因此要从注册表获取
    # vista sp2 iso 安装 KB4474419 后, CurrentBuild 是 6002, CurrentBuildNumber 是 6003
    build_ver=$(get_current_version_key CurrentBuildNumber)

    # rev_ver
    # 实测 win10 winver 是从 UBR 读取 revision 版本
    # vista sp2 iso 没有 UBR，后期有月度汇总更新包时才有 UBR
    if ! rev_ver=$(get_current_version_key UBR 2>/dev/null); then
        rev_ver=$(get_current_version_key BuildLabEx | cut -d. -f2)
    fi

    echo "Version: $nt_ver.$build_ver.$rev_ver" >&2
    apk del hivex-perl
}

is_elts() {
    [ -n "$elts" ] && [ "$elts" = 1 ]
}

is_need_set_ssh_keys() {
    [ -s /configs/ssh_keys ]
}

is_need_change_ssh_port() {
    [ -n "$ssh_port" ] && ! [ "$ssh_port" = 22 ]
}

is_need_change_rdp_port() {
    [ -n "$rdp_port" ] && ! [ "$rdp_port" = 3389 ]
}

is_need_manual_set_dnsv6() {
    # 有没有可能是静态但是有 rdnss？
    ! is_have_ipv6 && return $FALSE
    is_dhcpv6 && return $FALSE
    is_staticv6 && return $TRUE
    is_slaac && ! is_enable_other_flag &&
        { ! is_have_rdnss || { is_have_rdnss && is_windows && ! is_windows_support_rdnss; }; }
}

get_current_dns() {
    mark=$(
        case "$1" in
        4) echo . ;;
        6) echo : ;;
        esac
    )
    # debian 11 initrd 没有 xargs awk
    # debian 12 initrd 没有 xargs
    if false; then
        grep '^nameserver' /etc/resolv.conf | awk '{print $2}' | grep -F "$mark" | cut -d '%' -f1
    else
        grep '^nameserver' /etc/resolv.conf | cut -d' ' -f2 | grep -F "$mark" | cut -d '%' -f1
    fi
}

to_upper() {
    tr '[:lower:]' '[:upper:]'
}

to_lower() {
    tr '[:upper:]' '[:lower:]'
}

del_cr() {
    sed 's/\r$//'
}

del_comment_lines() {
    sed '/^[[:space:]]*#/d'
}

del_empty_lines() {
    sed '/^[[:space:]]*$/d'
}

del_head_empty_lines_inplace() {
    # 从第一行直到找到 ^[:space:]
    # 这个区间内删除所有空行
    sed -i '1,/[^[:space:]]/ { /^[[:space:]]*$/d }' "$@"
}

get_part_num_by_part() {
    dev_part=$1
    echo "$dev_part" | grep -o '[0-9]*' | tail -1
}

get_fallback_efi_file_name() {
    case $(arch) in
    x86_64) echo bootx64.efi ;;
    aarch64) echo bootaa64.efi ;;
    *) error_and_exit ;;
    esac
}

del_invalid_efi_entry() {
    info "del invalid EFI entry"
    apk add lsblk efibootmgr

    efibootmgr --quiet --remove-dups

    while read -r line; do
        part_uuid=$(echo "$line" | awk -F ',' '{print $3}')
        efi_index=$(echo "$line" | grep_efi_index)
        if ! lsblk -o PARTUUID | grep -q "$part_uuid"; then
            echo "Delete invalid EFI Entry: $line"
            efibootmgr --quiet --bootnum "$efi_index" --delete-bootnum
        fi
    done < <(efibootmgr | grep 'HD(.*,GPT,')
}

# reinstall.sh 有同名方法
grep_efi_index() {
    awk '{print $1}' | sed -e 's/Boot//' -e 's/\*//'
}

# 某些机器可能不会回落到 bootx64.efi
# 阿里云 ECS 启动项有 EFI Shell
# 添加 bootx64.efi 到最后的话，会进入 EFI Shell
# 因此添加到最前面
add_default_efi_to_nvram() {
    info "add default EFI to nvram"

    apk add lsblk efibootmgr

    if efi_row=$(lsblk /dev/$xda -ro NAME,PARTTYPE,PARTUUID | grep -i "$EFI_UUID"); then
        efi_part_uuid=$(echo "$efi_row" | awk '{print $3}')
        efi_part_name=$(echo "$efi_row" | awk '{print $1}')
        efi_part_num=$(get_part_num_by_part "$efi_part_name")
        efi_file=$(get_fallback_efi_file_name)

        # 创建条目，先判断是否已经存在
        # 好像没必要先判断
        if true || ! efibootmgr | grep -i "HD($efi_part_num,GPT,$efi_part_uuid,.*)/File(\\\EFI\\\boot\\\\$efi_file)"; then
            efibootmgr --create \
                --disk "/dev/$xda" \
                --part "$efi_part_num" \
                --label "$efi_file" \
                --loader "\\EFI\\boot\\$efi_file"
        fi
    else
        # shellcheck disable=SC2154
        if [ "$confirmed_no_efi" = 1 ]; then
            echo 'Confirmed no EFI in previous step.'
        else
            # reinstall.sh 里确认过一遍，但是逻辑扇区大于 512 时，可能漏报？
            # 这里的应该会根据逻辑扇区来判断？
            echo "
Warning: This machine is currently using EFI boot, but the main hard drive does not have an EFI partition.
If this machine supports Legacy BIOS boot (CSM), you can safely restart into the new system by running the reboot command.
If this machine does not support Legacy BIOS boot (CSM), you will not be able to enter the new system after rebooting.

警告：本机目前使用 EFI 引导，但主硬盘没有 EFI 分区。
如果本机支持 Legacy BIOS 引导 (CSM)，你可以运行 reboot 命令安全地重启到新系统。
如果本机不支持 Legacy BIOS 引导 (CSM)，重启后将无法进入新系统。
"
            exit
        fi
    fi
}

unix2dos() {
    target=$1

    # 先原地unix2dos，出错再用cat，可最大限度保留文件权限
    if ! command unix2dos $target 2>/tmp/unix2dos.log; then
        # 出错后删除 unix2dos 创建的临时文件
        rm "$(awk -F: '{print $2}' /tmp/unix2dos.log | xargs)"
        tmp=$(mktemp)
        cp $target $tmp
        command unix2dos $tmp
        # cat 可以保留权限
        cat $tmp >$target
        rm $tmp
    fi
}

insert_into_file() {
    local file=$1
    local location=$2
    local regex_to_find=$3
    shift 3

    if ! [ -f "$file" ]; then
        error_and_exit "File not found: $file"
    fi

    # 默认 grep -E
    if [ $# -eq 0 ]; then
        set -- -E
    fi

    if [ "$location" = head ]; then
        bak=$(mktemp)
        cp $file $bak
        cat - $bak >$file
    else
        line_num=$(grep "$@" -n "$regex_to_find" "$file" | cut -d: -f1)

        found_count=$(echo "$line_num" | wc -l)
        if [ ! "$found_count" -eq 1 ]; then
            return 1
        fi

        case "$location" in
        before) line_num=$((line_num - 1)) ;;
        after) ;;
        *) return 1 ;;
        esac

        sed -i "${line_num}r /dev/stdin" "$file"
    fi
}

get_eths() {
    (
        cd /dev/netconf
        ls
    )
}

is_distro_like_debian() {
    [ "$distro" = debian ] || [ "$distro" = kali ]
}

create_ifupdown_config() {
    conf_file=$1

    rm -f $conf_file

    if is_distro_like_debian; then
        cat <<EOF >>$conf_file
source /etc/network/interfaces.d/*

EOF
    fi

    # 生成 lo配置
    cat <<EOF >>$conf_file
auto lo
iface lo inet loopback
EOF

    # ethx
    for ethx in $(get_eths); do
        mode=auto
        # shellcheck disable=SC2154
        if false; then
            if { [ "$distro" = debian ] && [ "$releasever" -ge 12 ]; } ||
                [ "$distro" = kali ]; then
                # alice + allow-hotplug 会有问题
                # 问题 1 debian 9/10/11/12:
                # 如果首次启动时，/etc/networking/interfaces 的 ethx 跟安装时不同
                # 即使启动 networking 服务前成功执行了 fix-eth-name.sh ，网卡也不会启动
                # 测试方法: 安装时手动修改 /etc/networking/interfaces enp3s0 为其他名字
                # 问题 2 debian 9/10/11:
                # 重启系统后会自动启动网卡，但运行 systemctl restart networking 会关闭网卡
                # 可能的原因: /lib/systemd/system/networking.service 没有 hotplug 相关内容，而 debian 12+ 有
                if [ -f /etc/network/devhotplug ] && grep -wo "$ethx" /etc/network/devhotplug; then
                    mode=allow-hotplug
                fi
            fi

            # if is_have_cmd udevadm; then
            #     enpx=$(udevadm test-builtin net_id /sys/class/net/$ethx 2>&1 | grep ID_NET_NAME_PATH= | cut -d= -f2)
            # fi
        fi

        # dmit debian 普通内核和云内核网卡名不一致，因此需要 rename
        # 安装系统时 ens18
        # 普通内核   ens18
        # 云内核     enp6s18
        # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=928923

        # 头部
        get_netconf_to mac_addr
        {
            echo
            # 这是标记，fix-eth-name 要用，不要删除
            # shellcheck disable=SC2154
            echo "# mac $mac_addr"
            echo $mode $ethx
        } >>$conf_file

        # ipv4
        if is_dhcpv4; then
            echo "iface $ethx inet dhcp" >>$conf_file

        elif is_staticv4; then
            get_netconf_to ipv4_addr
            get_netconf_to ipv4_gateway
            cat <<EOF >>$conf_file
iface $ethx inet static
    address $ipv4_addr
    gateway $ipv4_gateway
EOF
            # dns
            if list=$(get_current_dns 4); then
                for dns in $list; do
                    cat <<EOF >>$conf_file
    dns-nameservers $dns
EOF
                done
            fi
        fi

        # ipv6
        has_ipv6_iface=false
        if is_slaac; then
            echo "iface $ethx inet6 auto" >>$conf_file
            has_ipv6_iface=true
        elif is_dhcpv6; then
            # debian 13 使用 ifupdown + dhcpcd-base
            # inet/inet6 都配置成 dhcp 时，重启后 dhcpv4 会丢失
            # 手动 systemctl restart networking 后正常
            # 删除 dhcpcd-base 安装 isc-dhcp-client（类似 debian 12 升级到 13），轮到 dhcpv6 丢失
            if { [ "$distro" = debian ] && [ "$releasever" -ge 13 ]; } ||
                [ "$distro" = kali ]; then
                echo "iface $ethx inet6 auto" >>$conf_file
            else
                echo "iface $ethx inet6 dhcp" >>$conf_file
            fi
            has_ipv6_iface=true
        elif is_staticv6; then
            get_netconf_to ipv6_addr
            get_netconf_to ipv6_gateway
            cat <<EOF >>$conf_file
iface $ethx inet6 static
    address $ipv6_addr
    gateway $ipv6_gateway
EOF
            has_ipv6_iface=true
            # debian 9
            # ipv4 支持静态 onlink 网关
            # ipv6 不支持静态 onlink 网关，需使用 post-up 添加，未测试动态
            # ipv6 也不支持直接 ip route add default via xxx onlink
            if [ "$distro" = debian ] && [ "$releasever" -le 9 ]; then
                # debian 添加 gateway 失败时不会执行 post-up
                # 因此 gateway post-up 只能二选一

                # 注释最后一行，也就是 gateway
                sed -Ei '$s/^( *)/\1# /' "$conf_file"
                cat <<EOF >>$conf_file
    post-up ip route add $ipv6_gateway dev $ethx
    post-up ip route add default via $ipv6_gateway dev $ethx
EOF
            fi

            # 额外的 IPv6 地址（子网不含网关的地址）
            get_netconf_to ipv6_extra_addrs
            if [ -n "$ipv6_extra_addrs" ]; then
                (
                    IFS=','
                    for _addr in $ipv6_extra_addrs; do
                        echo "    post-up ip -6 addr add $_addr dev $ethx" >>$conf_file
                    done
                )
            fi
        fi
        # accept_ra/autoconf 属于 iface 选项
        # 如果当前网卡没有生成 IPv6 iface stanza，
        # 先补一个 manual stanza，避免 ifupdown 报 misplaced option
        if ! $has_ipv6_iface &&
            { should_disable_accept_ra || should_disable_autoconf; } &&
            [ "$distro" != alpine ]; then
            echo "iface $ethx inet6 manual" >>$conf_file
        fi
        # dns
        # 有 ipv6 但需设置 dns 的情况
        if is_need_manual_set_dnsv6; then
            for dns in $(get_current_dns 6); do
                cat <<EOF >>$conf_file
    dns-nameserver $dns
EOF
            done
        fi

        # 禁用 ra
        if should_disable_accept_ra; then
            if [ "$distro" = alpine ]; then
                cat <<EOF >>$conf_file
    pre-up echo 0 >/proc/sys/net/ipv6/conf/$ethx/accept_ra
EOF
            else
                cat <<EOF >>$conf_file
    accept_ra 0
EOF
            fi
        fi

        # 禁用 autoconf
        if should_disable_autoconf; then
            if [ "$distro" = alpine ]; then
                cat <<EOF >>$conf_file
    pre-up echo 0 >/proc/sys/net/ipv6/conf/$ethx/autoconf
EOF
            else
                cat <<EOF >>$conf_file
    autoconf 0
EOF
            fi
        fi
    done
}

newline_to_comma() {
    tr '\n' ','
}

space_to_newline() {
    sed 's/ /\n/g'
}

trim() {
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//'
}

quote_word() {
    sed -E 's/([^[:space:]]+)/"\1"/g'
}

quote_line() {
    awk '{print "\""$0"\""}'
}

add_space() {
    space_count=$1

    spaces=$(printf '%*s' "$space_count" '')
    sed "s/^/$spaces/"
}

# 不够严谨，谨慎使用
nix_replace() {
    local key=$1
    local value=$2
    local type=$3
    local file=$4
    local key_ value_

    key_=$(echo "$key" | sed 's \. \\\. g') # . 改成 \.

    if [ "$type" = array ]; then
        local value_="[ $value ]"
    fi

    sed -i "s/$key_ =.*/$key = $value_;/" "$file"
}

create_nixos_network_config() {
    conf_file=$1
    true >$conf_file

    # 头部
    cat <<EOF >>$conf_file
networking = {
  usePredictableInterfaceNames = false;
EOF

    for ethx in $(get_eths); do
        # ipv4 使用 DHCP 时显式开启 useDHCP
        if is_dhcpv4; then
            cat <<EOF >>$conf_file
  interfaces.$ethx.useDHCP = true;
EOF
        fi

        # ipv4
        if is_staticv4; then
            get_netconf_to ipv4_addr
            get_netconf_to ipv4_gateway
            IFS=/ read -r address prefix < <(echo "$ipv4_addr")
            cat <<EOF >>$conf_file
  interfaces.$ethx.ipv4.addresses = [
    {
      address = "$address";
      prefixLength = $prefix;
    }
  ];
  defaultGateway = {
    address = "$ipv4_gateway";
    interface = "$ethx";
  };
EOF
        fi

        # ipv6
        if is_staticv6; then
            get_netconf_to ipv6_addr
            get_netconf_to ipv6_gateway
            IFS=/ read -r address prefix < <(echo "$ipv6_addr")
            cat <<EOF >>$conf_file
  interfaces.$ethx.ipv6.addresses = [
    {
      address = "$address";
      prefixLength = $prefix;
    }
  ];
  defaultGateway6 = {
    address = "$ipv6_gateway";
    interface = "$ethx";
  };
EOF
        fi
    done

    # 全局 dns
    need_set_dns=false
    for ethx in $(get_eths); do
        if is_staticv4 || is_staticv6 || is_need_manual_set_dnsv6; then
            need_set_dns=true
            break
        fi
    done

    if $need_set_dns; then
        cat <<EOF >>$conf_file
  nameservers = [
$(get_current_dns | quote_line | add_space 4)
  ];
EOF
    fi

    # 尾部
    cat <<EOF >>$conf_file
};
EOF

    # nixos 默认网络管理器是 dhcpcd
    # 但配置静态 ip 时用的是脚本
    # /nix/store/qcr1xxjdxcrnwqwrgysqpxx2aibp9fdl-unit-script-network-addresses-eth0-start/bin/network-addresses-eth0-start
    # ...
    # if out=$(ip addr replace "181.x.x.x/24" dev "eth0" 2>&1); then
    #   echo "done"
    # else
    #   echo "'ip addr replace "181.x.x.x/24" dev "eth0"' failed: $out"
    #   exit 1
    # fi
    # ...

    # 禁用 ra/autoconf
    local mode=1
    for ethx in $(get_eths); do
        if should_disable_accept_ra; then
            case "$mode" in
            1)
                cat <<EOF >>$conf_file
boot.kernel.sysctl."net.ipv6.conf.$ethx.accept_ra" = false;
EOF
                ;;
            2)
                # nixos 配置静态 ip 时用的是脚本
                # 好像因此不起作用
                cat <<EOF >>$conf_file
networking.dhcpcd.extraConfig =
  ''
    interface $ethx
      ipv6ra_noautoconf
  '';
EOF
                ;;
            3)
                # 暂时没用到 networkd
                cat <<EOF >>$conf_file
systemd.network.networks.$ethx = {
   matchConfig.Name = "$ethx";
   networkConfig = {
     IPv6AcceptRA = false;
   };
 };
EOF
                ;;
            esac
        fi

        if should_disable_autoconf; then
            case "$mode" in
            1)
                cat <<EOF >>$conf_file
boot.kernel.sysctl."net.ipv6.conf.$ethx.autoconf" = false;
EOF
                ;;
            2) ;;
            3) ;;
            esac
        fi
    done
}

install_alpine() {
    info "install alpine"

    need_ram=512
    swap_size=$(get_need_swap_size $need_ram)
    [ "$swap_size" -gt 0 ] && hack_lowram=true || hack_lowram=false

    # alpine 安装时会自动检测安装需要的 firmware
    # https://github.com/alpinelinux/alpine-conf/blob/3.18.1/setup-disk.in#L421
    # 但如果没有 modloop 则无法检测
    # 所以删除 modloop 前先记录用到的 firmware 包
    fw_pkgs=$(get_alpine_firmware_pkgs)

    if $hack_lowram; then
        # 预先加载需要的模块
        if rc-service -q modloop status; then
            modules="ext4 vfat nls_utf8 nls_cp437"
            for mod in $modules; do
                modprobe $mod
            done
            # crc32c 等于 crc32c-intel
            # 没有 sse4.2 的机器加载 crc32c 时会报错 modprobe: ERROR: could not insert 'crc32c_intel': No such device
            modprobe crc32c || modprobe crc32c-generic
        fi

        # 删除 modloop ，释放内存
        ensure_service_stopped modloop
        rm -f /lib/modloop-lts /lib/modloop-virt
    fi

    # bios机器用 setup-disk 自动分区会有 boot 分区
    # 因此手动分区安装
    create_part
    mount_part_basic_layout /os /os/boot/efi

    # 创建 swap
    if $hack_lowram; then
        create_swap $swap_size /os/swapfile
    fi

    # 网络配置
    create_ifupdown_config /etc/network/interfaces
    echo
    cat -n /etc/network/interfaces
    echo

    # 在 arm netboot initramfs init 中
    # 如果识别到rtc硬件，就往系统添加hwclock服务，否则添加swclock
    # 这个设置也被复制到安装的系统中
    # 但是从initramfs chroot到真正的系统后，是能识别rtc硬件的
    # 所以我们手动改用hwclock修复这个问题
    rc-update del swclock boot || true
    rc-update add hwclock boot

    # 通过 setup-alpine 安装会启用以下几个服务
    # https://github.com/alpinelinux/alpine-conf/blob/3.18.1/setup-alpine.in#L229

    # boot
    rc-update add networking boot
    rc-update add seedrng boot

    # default
    rc-update add crond
    if [ -e /dev/input/event0 ]; then
        rc-update add acpid
    fi

    # 内核
    # shellcheck disable=SC2154
    if [ "$no_cloud_kernel" = 1 ]; then
        kernel_flavor=lts
    else
        if is_virt; then
            kernel_flavor=virt
        else
            kernel_flavor=lts
        fi
    fi

    # 重置为官方仓库配置
    # 国内机可能无法访问mirror列表而报错
    if false; then
        true >/etc/apk/repositories
        setup-apkrepos -1
    fi

    # setup-disk 安装 grub 跳过了添加引导项到 nvram
    # 防止部分机器不会 fallback 到 bootx64.efi
    if is_efi; then
        apk add efibootmgr
        sed -i 's/--no-nvram//' "$(which setup-disk)"
    fi

    # 安装到硬盘
    # alpine默认使用 syslinux (efi 环境除外)，这里强制使用 grub，方便用脚本再次重装
    KERNELOPTS="$(get_ttys console=)"
    export KERNELOPTS
    export BOOTLOADER="grub"
    setup-disk -m sys -k $kernel_flavor /os

    # 删除 setup-disk 时自动安装的包
    apk del e2fsprogs dosfstools efibootmgr grub*

    # 如果没有挂载 /proc

    # 1. chroot /os setup-keymap us us 会报错
    # grep: /proc/filesystems: No such file or directory

    # 2. 安装固件微码会触发 grub-probe，如果没挂载会报错
    # Executing grub-2.12-r5.trigger
    # /usr/sbin/grub-probe: error: failed to get canonical path of `/dev/vda1'.
    # ERROR: grub-2.12-r5.trigger: script exited with error 1

    mount_pseudo_fs /os

    # azure nvme 实例的 initramfs 需要添加 pci_hyperv 驱动
    if [ -d /sys/module/pci_hyperv ] &&
        get_drivers "/sys/block/$xda" | grep -qx pci_hyperv; then
        echo 'kernel/drivers/pci/controller/pci-hyperv.ko*' >/os/etc/mkinitfs/features.d/pci-hyperv.modules
        if ! grep -q 'pci-hyperv' /os/etc/mkinitfs/mkinitfs.conf; then
            # 找到 features=" 开头的行，将最后的"改成 pci-hyperv"
            sed -i '/features="/s/"$/ pci-hyperv"/' /os/etc/mkinitfs/mkinitfs.conf
        fi
        chroot /os mkinitfs -k "$(basename /os/lib/modules/*-*)"
    fi

    # 安装到硬盘后才安装各种应用
    # 避免占用 Live OS 内存

    # 网络
    # udhcpc
    # 坑1 ip -4 addr 无法知道是否是 dhcp
    # 坑2 networking 服务不会运行 udhcpc6
    # 坑3 h3c 移动云电脑 udhcpc6 无法获取 dhcpv6

    # dhcpcd
    # 坑1 slaac默认开了隐私保护，造成ip和后台面板不一致

    # slaac方案1: udhcpc + rdnssd
    # slaac方案2: dhcpcd + 关闭隐私保护
    # dhcpv6方案: dhcpcd

    # 综合使用dhcpcd方案
    # 1 无需改动/etc/network/interfaces，自动根据ra使用slaac和dhcpv6
    # 2 自带rdnss支持
    # 3 唯一要做的是关闭隐私保护

    # 安装 dhcpcd
    chroot /os apk add dhcpcd
    chroot /os sed -i '/^slaac private/s/^/#/' /etc/dhcpcd.conf
    chroot /os sed -i '/^#slaac hwaddr/s/^#//' /etc/dhcpcd.conf

    # 安装其他部件
    chroot /os setup-keymap us us
    chroot /os setup-timezone -i Asia/Shanghai
    # 3.21 默认是 chrony
    # 3.22 默认是 busybox ntp
    printf '\n' | chroot /os setup-ntp || true

    # 设置公钥
    add_user_if_need /os
    if is_need_set_ssh_keys; then
        set_ssh_keys_and_del_password /os
    fi

    # alpine 3.24+
    # 要从 /etc/inittab 删除多余的 tty0
    # 否则开机时 vnc 会有两个登录提示，一个是 tty0，一个是 tty1

    # sed 找到 # enable login on alternative console 的行
    # 用 N 读取下一行到当前空间
    # 再匹配 \ntty0:
    sed -i '
/^# enable login on alternative console$/{
    N
    /\ntty0:/d
}
' /os/etc/inittab

    # 下载 fix-eth-name
    download "$confhome/fix-eth-name.sh" /os/fix-eth-name.sh
    download "$confhome/fix-eth-name.initd" /os/etc/init.d/fix-eth-name
    chmod +x /os/etc/init.d/fix-eth-name
    chroot /os rc-update add fix-eth-name boot

    # 安装 frpc
    if ls /configs/frpc.* >/dev/null 2>&1; then
        chroot /os apk add frp
        # chroot rc-update add 默认添加到 sysinit
        # 但不加 chroot 默认添加到 default
        chroot /os rc-update add frpc boot
        cp -f /configs/frpc.* /os/etc/frp/
        chmod 600 /os/etc/frp/frpc.*
    fi

    # setup-disk 会自动选择固件，但不包括微码？
    # https://github.com/alpinelinux/alpine-conf/blob/3.18.1/setup-disk.in#L421
    if fw_pkgs="$fw_pkgs $(get_ucode_firmware_pkgs)" && [ -n "$fw_pkgs" ]; then
        chroot /os apk add $fw_pkgs
    fi

    # 3.19 或以上，非 efi 需要手动安装 grub
    if ! is_efi; then
        chroot /os grub-install --target=i386-pc /dev/$xda
    fi

    # efi grub 添加 fwsetup 条目
    chroot /os update-grub

    # 是否保留 swap
    if [ -e /os/swapfile ]; then
        if false; then
            echo "/swapfile swap swap defaults 0 0" >>/os/etc/fstab
            ln -sf /etc/init.d/swap /os/etc/runlevels/boot/swap
        else
            swapoff -a
            rm /os/swapfile
        fi
    fi
}

get_cpu_vendor() {
    cpu_vendor=$(grep 'vendor_id' /proc/cpuinfo | head -1 | awk '{print $NF}')
    case "$cpu_vendor" in
    GenuineIntel) echo intel ;;
    AuthenticAMD) echo amd ;;
    *) echo other ;;
    esac
}

min() {
    printf "%d\n" "$@" | sort -n | head -n 1
}

# 设置线程
# 根据 cpu 核数，每个线程的内存，取最小值
get_build_threads() {
    threads_per_mb=$1

    threads_by_core=$(nproc)
    threads_by_ram=$(($(get_approximate_ram_size) / threads_per_mb))
    [ $threads_by_ram -eq 0 ] && threads_by_ram=1
    min $threads_by_ram $threads_by_core
}

add_newline() {
    # shellcheck disable=SC1003
    case "$1" in
    head | start) sed -e '1s/^/\n/' ;;
    tail | end) sed -e '$a\\' ;;
    both) sed -e '1s/^/\n/' -e '$a\\' ;;
    esac
}

install_nixos() {
    info "Install NixOS"

    local os_dir=/os
    keep_swap=true
    nix_from=website
    ram_per_thread=2048

    threads=$(get_build_threads $ram_per_thread)
    swap_size=$(get_need_swap_size $ram_per_thread)

    show_nixos_config() {
        echo
        # 过滤 frp auth.token
        cat -n /os/etc/nixos/configuration.nix | grep -Fv 'auth.token'
        echo
        cat -n /os/etc/nixos/hardware-configuration.nix
        echo
    }

    # 挂载分区，创建 swapfile
    mount_part_basic_layout /os /os/efi
    if [ "$swap_size" -gt 0 ]; then
        create_swap "$swap_size" /os/swapfile
    fi

    # 步骤
    # 1. 安装 nix (nix-xxx)
    # 2. 用 nix 安装 nixos-install-tools (nixos-xxx)
    # 3. 运行 nixos-generate-config 生成配置 + 编辑
    # 4. 运行 nixos-install
    # https://nixos.org/manual/nixos/stable/index.html#sec-installing-from-other-distro

    # nix 安装方式                                    分支          版本
    # apk add nix                                    3.20         2.22.0  # nix 本体跟 alpine 正常的软件一样，不在 /nix/store 里面
    # env -iA nixpkgs.nix                            24.05        2.18.5
    # sh <(curl -L https://nixos.org/nix/install)   unstable?     2.24.2

    # apk add 安装的 nix 有时会卡在
    # copying path '/nix/store/gcbrjlfm5h21ybf1h2lfq773zafjmzjr-curl-8.7.1-man' from 'https://cache.nixos.org'...
    # 但是 cpu 空载

    # 安装 nix
    mkdir -p /os/nix /nix
    mount --bind /os/nix /nix

    # nix 安装脚本和 /root/.nix-profile/etc/profile.d/nix.sh 都会用到这两个变量
    # 但从 alpine local.d 运行没有这两个变量
    export USER=root
    export HOME=/root

    # 也可以用 export NIX_CONFIG 和 --option substituters https://mirror.nju.edu.cn/nix-channels/store
    # https://help.mirrorz.org/nix-channels/
    configure_nix_substituters() {
        if ! is_in_china; then
            return
        fi

        nix_conf=/etc/nix/nix.conf
        mkdir -p "$(dirname "$nix_conf")"

        if [ -f "$nix_conf" ]; then
            sed -i '/^[[:space:]]*substituters[[:space:]]*=/d' "$nix_conf"
        fi

        echo "substituters = $mirror/store" >>"$nix_conf"
    }

    case "$nix_from" in
    alpine)
        apk add nix
        # 设置 nix 镜像和线程
        # alpine 默认设置了 4 线程
        # https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/community/nix/APKBUILD#L125
        sed -i '/max-jobs/d' /etc/nix/nix.conf
        echo "max-jobs = $threads" >>/etc/nix/nix.conf
        configure_nix_substituters
        rc-service -q nix-daemon restart
        # 添加 nix-env 安装的软件到 PATH
        PATH="/root/.nix-profile/bin:$PATH"
        ;;
    website)
        # https://gitlab.alpinelinux.org/alpine/aports/-/blob/master/community/nix/nix.pre-install
        # https://nix.dev/manual/nix/latest/installation/multi-user
        if ! grep -q nixbld /etc/passwd; then
            addgroup -S nixbld
            for n in $(seq 1 10); do
                adduser -S -D -H -h /var/empty -s /sbin/nologin -G nixbld \
                    -g "Nix build user $n" nixbld$n
            done
        fi

        # 备用方案
        # 1. 从 https://mirror.nju.edu.cn/nix-channels/nixos-26.05/nixexprs.tar.xz 获取
        #    https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/tools/package-management/nix/default.nix
        #    https://github.com/NixOS/nixpkgs/blob/nixos-26.05/nixos/modules/installer/tools/nix-fallback-paths.nix
        # 2. 安装最新版 nix，添加 nixos channel 后获取
        #    nix eval -f '<nixpkgs>' --raw 'nixVersions.stable.version' --extra-experimental-features nix-command

        if true; then
            # nix 版本号使用目标系统里面的
            download $mirror/nixos-$releasever/store-paths.xz /os/store-paths.xz
            apk add xz
            nix_ver=$(xz -dc </os/store-paths.xz | grep -F 'vm-test-run-nix-upgrade' |
                head -1 | awk -F- '{print $7}' | grep .)
            rm -f /os/store-paths.xz
            if is_in_china; then
                sh_mirror=https://mirror.nju.edu.cn/nix
            else
                sh_mirror=https://releases.nixos.org/nix
            fi
            sh=$sh_mirror/nix-$nix_ver/install
        else
            # 最新版 nix 在 nixos-install 时可能会出问题
            # https://github.com/bin456789/reinstall/issues/451
            if is_in_china; then
                sh=https://mirror.nju.edu.cn/nix/latest/install
            else
                sh=https://nixos.org/nix/install
            fi
        fi

        apk add xz
        wget -O- "$sh" | sh -s -- --no-daemon --no-channel-add
        apk del xz
        # shellcheck source=/dev/null
        . /root/.nix-profile/etc/profile.d/nix.sh
        configure_nix_substituters
        ;;
    esac

    # 添加 channel
    # shellcheck disable=SC2154
    nix-channel --add $mirror/nixos-$releasever nixpkgs
    nix-channel --update

    # 安装 channal 的 nix
    # shellcheck source=/dev/null
    if false; then
        nix-env -iA nixpkgs.nix -j $threads
        . ~/.nix-profile/etc/profile.d/nix.sh
    fi

    # 安装 nixos-install-tools
    nix-env -iA nixpkgs.nixos-install-tools -j $threads

    # 安装 nixfmt
    nix-env -iA nixpkgs.nixfmt -j $threads

    # 生成配置并显示
    nixos-generate-config --root /os
    echo "Original NixOS Configuration:"
    show_nixos_config

    # 修改 configuration.nix
    if is_efi; then
        nix_bootloader="boot.loader.efi.efiSysMountPoint = \"/efi\";"
    else
        nix_bootloader="boot.loader.grub.device = \"/dev/$xda\";"
    fi

    if is_in_china; then
        nix_substituters="nix.settings.substituters = lib.mkForce [ \"$mirror/store\" ];"
    fi

    if [ -e /os/swapfile ] && $keep_swap; then
        nix_swap="swapDevices = [ { device = \"/swapfile\"; size = $swap_size; } ];"
    fi

    # keys
    if is_need_set_ssh_keys; then
        nix_user_keys_fragment="
openssh.authorizedKeys.keys = [
$(del_comment_lines </configs/ssh_keys | del_empty_lines | quote_line | add_space 2)
];
"
    fi

    # root user
    if [ "$username" = root ]; then
        if is_need_set_ssh_keys; then
            nix_users="
users.users.$username = {
$(echo "$nix_user_keys_fragment" | add_space 2)
};
"
        else
            nix_users=""
        fi
    else
        # normal user
        # https://nixos.org/manual/nixos/stable/#sec-user-management
        nix_users=$(
            cat <<EOF
users.users.$username = {
  isNormalUser = true;
  home = "/home/$username";
  extraGroups = [
    "wheel"
    "networkmanager"
  ];
$(echo "$nix_user_keys_fragment" | add_space 2)
};

security.sudo.extraRules = [
  { users = [ "$username" ]; commands = [ { command = "ALL"; options = [ "NOPASSWD" ]; } ]; }
];
EOF
        )
    fi

    # openssh
    nix_openssh="
services.openssh = {
  enable = true;
$(
        {
            if is_need_change_ssh_port; then
                echo "ports = [ $ssh_port ];"
            fi
            if is_need_set_ssh_keys; then
                echo 'settings.PasswordAuthentication = false;'
                echo 'settings.KbdInteractiveAuthentication = false;'
            fi
            if [ "$username" = root ] && ! is_need_set_ssh_keys; then
                echo 'settings.PermitRootLogin = "yes";'
            fi
        } | add_space 2
    )
};
"

    # frpc
    if ls /configs/frpc.* >/dev/null 2>&1; then
        nix_frpc=$(
            if false; then
                # 原始 frpc.toml 转 toml 对象 ，再转成最终使用的 frpc.toml
                # 可以避免原始 frpc.toml 有错误导致失联
                # 但是 frpc 配置还支持 ini json yaml
                # 因此不使用这个方法
                cat <<EOF
services.frp = {
  enable = true;
  role = "client";
  settings = builtins.fromTOML ''
$(cat /configs/frpc.* | add_space 4)
  '';
};
EOF
            else
                # 直接使用原始文件
                cp /configs/frpc.* /os/etc/nixos/
                chmod 600 /os/etc/nixos/frpc.*
                ext=$(basename /configs/frpc.* | awk -F. '{print $NF}')
                cat <<EOF
services.frp = {
  enable = true;
  role = "client";
};
systemd.services.frp.serviceConfig = {
  LoadCredential = "frpc.$ext:/etc/nixos/frpc.$ext";
  ExecStart = lib.mkForce "\${pkgs.frp}/bin/frpc -c \\\${CREDENTIALS_DIRECTORY}/frpc.$ext";
};
EOF
            fi
        )
    fi

    # TODO: 准确匹配网卡，添加 udev 或者直接配置 networkd 匹配 mac
    create_nixos_network_config /tmp/nixos_network_config.nix

    del_empty_lines <<EOF | add_space 2 | add_newline both |
############### Add by reinstall.sh ###############
$nix_bootloader
$nix_swap
$nix_substituters
boot.kernelParams = [ $(get_ttys console= | quote_word) ];
$nix_users
$nix_openssh
$nix_frpc
$(cat /tmp/nixos_network_config.nix)
###################################################
EOF
        insert_into_file /os/etc/nixos/configuration.nix before "networking.hostName" -F

    # 修改 hardware-configuration.nix
    # 在 vultr efi 机器上，nixos-generate-config 不会添加 virtio_pci
    # 导致 virtio_blk 用不了，启动时 initrd 找不到系统分区
    # 可能由于 alpine 的 virtio_pci 编译进内核而不是模块
    # 因此 nixos-generate-config 不会添加 virtio_pci 到配置文件
    olds=$(
        grep -F 'boot.initrd.availableKernelModules' /os/etc/nixos/hardware-configuration.nix |
            cut -d= -f2 | tr -d '"[];' | xargs
    )
    alls="$olds"
    # https://github.com/search?q=repo%3ANixOS%2Fnixpkgs+availableKernelModules&type=code
    for mod in ahci ata_piix uhci_hcd sr_mod nvme vmd \
        virtio_pci virtio_blk virtio_scsi \
        xen_blkfront xen_scsifront \
        hv_storvsc pci_hyperv \
        vmw_pvscsi \
        mptspi; do
        if [ -d /sys/module/$mod ] && ! echo "$olds" | grep -wq "$mod"; then
            echo "Adding modules: $mod"
            alls="$alls $mod"
        fi
    done
    # 去除多余的空格
    alls=$(echo "$alls" | xargs)

    # boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "sr_mod" "virtio_blk" ];
    nix_replace \
        boot.initrd.availableKernelModules \
        "$(echo "$alls" | quote_word)" \
        array \
        /os/etc/nixos/hardware-configuration.nix

    # 格式化
    nixfmt /os/etc/nixos/configuration.nix
    nixfmt /os/etc/nixos/hardware-configuration.nix

    # 显示修改后的配置
    echo "Modified NixOS Configuration:"
    show_nixos_config

    # 安装系统
    nixos-install --root /os --no-root-passwd -j $threads

    # 设置密码
    if ! is_need_set_ssh_keys; then
        printf '%s\n' "$username:$(get_password_linux_sha512)" | nixos-enter --root /os -- \
            /run/current-system/sw/bin/chpasswd -e
    fi

    # 设置 channel
    if is_in_china; then
        nixos-enter --root /os -- \
            /run/current-system/sw/bin/nix-channel --add $mirror/nixos-$releasever nixos
    fi

    # 清理
    nix-env -e '*'
    # /nix/var/nix/profiles/system/sw/bin/nix-collect-garbage -d
    /nix/var/nix/profiles/system/sw/bin/nixos-enter --root /os -- \
        /run/current-system/sw/bin/nix-collect-garbage -d

    # 删除 nix
    umount /nix
    apk del nix

    # swapfile
    if [ -e /os/swapfile ]; then
        if $keep_swap; then
            :
        else
            swapoff -a
            rm -rf /os/swapfile
        fi
    fi

    # 重新显示配置，方便查看
    show_nixos_config
}

add_systemd_service() {
    local os_dir=$1
    local service_name=$2

    download "$confhome/$service_name.service" "$os_dir/etc/systemd/system/$service_name.service"
    chroot "$os_dir" systemctl enable "$service_name.service"

    # aosc 首次开机会执行 preset-all
    # 因此需要设置 fix-eth-name 的 preset 状态
    # 不然首次开机 /etc/systemd/system/multi-user.target.wants/fix-eth-name.service 会被删除
    # 通常 /etc/systemd/system-preset/ 文件夹要新建，因此不放在这里

    # 可能是 /usr/lib/systemd/system-preset/ 或者 /lib/systemd/system-preset/
    if [ -d "$os_dir/usr/lib/systemd/system-preset" ]; then
        echo "enable $service_name.service" >"$os_dir/usr/lib/systemd/system-preset/01-$service_name.preset"
    else
        echo "enable $service_name.service" >"$os_dir/lib/systemd/system-preset/01-$service_name.preset"
    fi
}

add_fix_eth_name_systemd_service() {
    local os_dir=$1

    # 无需执行 systemctl daemon-reload
    # 因为 chroot 下执行会提示 Running in chroot, ignoring command 'daemon-reload'
    download "$confhome/fix-eth-name.sh" "$os_dir/fix-eth-name.sh"
    add_systemd_service "$os_dir" fix-eth-name
}

get_frpc_url() {
    wget "$confhome/get-frpc-url.sh" -O- | sh -s "$@"
}

add_frpc_systemd_service_if_need() {
    local os_dir=$1

    if ls /configs/frpc.* >/dev/null 2>&1; then
        mkdir -p "$os_dir/usr/local/bin"
        mkdir -p "$os_dir/usr/local/etc/frpc"

        # 下载 frpc
        # 注意下载的 frpc owner 不是 root:root
        frpc_url=$(get_frpc_url linux)
        basename=$(echo "$frpc_url" | awk -F/ '{print $NF}' | sed 's/\.tar\.gz//')
        download "$frpc_url" "$os_dir/frpc.tar.gz"
        # busybox tar 不支持 wildcard
        # tar: */frpc: not found in archive
        tar xzf "$os_dir/frpc.tar.gz" "$basename/frpc" -O >"$os_dir/usr/local/bin/frpc"
        rm -f "$os_dir/frpc.tar.gz"
        chmod a+x "$os_dir/usr/local/bin/frpc"

        # frpc conf
        cp -f /configs/frpc.* "$os_dir/usr/local/etc/frpc/"
        chmod 600 $os_dir/usr/local/etc/frpc/frpc.*

        # 添加服务
        add_systemd_service "$os_dir" frpc
    fi
}

get_fs_of_mount_point() {
    local mount_point=$1

    if ! [ "$mount_point" = / ]; then
        # 删除最后的若干个 /
        mount_point=$(printf "%s" "$mount_point" | sed 's,/*$,,')
    fi

    # findmnt 要安装
    # findmnt "$mount_point" -rno FSTYPE
    mount | awk -v mp="$1" '$3==mp {print $5}' | grep .
}

basic_init() {
    local os_dir=$1

    # 此时不能用
    # chroot $os_dir timedatectl set-timezone Asia/Shanghai
    # Failed to create bus connection: No such file or directory

    # debian 11 没有 systemd-firstboot
    if is_have_cmd_on_disk $os_dir systemd-firstboot; then
        if chroot $os_dir systemd-firstboot --help | grep -wq '\--force'; then
            chroot $os_dir systemd-firstboot --timezone=Asia/Shanghai --force
        else
            chroot $os_dir systemd-firstboot --timezone=Asia/Shanghai
        fi
    fi

    # gentoo 不会自动创建 machine-id
    clear_machine_id $os_dir

    # sshd
    chroot $os_dir ssh-keygen -A

    sshd_enabled=false
    sshs="sshd.service ssh.service sshd.socket ssh.socket"
    for i in $sshs; do
        if chroot $os_dir systemctl -q is-enabled $i; then
            sshd_enabled=true
            break
        fi
    done
    if ! $sshd_enabled; then
        for i in $sshs; do
            if chroot $os_dir systemctl -q enable $i; then
                break
            fi
        done
    fi

    if is_need_change_ssh_port; then
        change_ssh_port $os_dir $ssh_port
    fi

    # 公钥/密码
    add_user_if_need "$os_dir"
    if is_need_set_ssh_keys; then
        set_ssh_keys_and_del_password $os_dir
        change_ssh_conf_for_key_login $os_dir
    else
        change_user_password $os_dir
        change_ssh_conf_for_password_login $os_dir
    fi

    # 下载 fix-eth-name.service
    # 即使开了 net.ifnames=0 也需要
    # 因为 alpine live 和目标系统的网卡顺序可能不同
    add_fix_eth_name_systemd_service $os_dir

    # frpc
    add_frpc_systemd_service_if_need $os_dir
}

install_arch_gentoo_aosc() {
    info "install $distro"

    network_app=$(
        case "$distro" in
        arch | gentoo) echo systemd-networkd ;;
        aosc) echo network-manager ;;
        esac
    )

    set_locale() {
        echo "C.UTF-8 UTF-8" >>$os_dir/etc/locale.gen
        chroot $os_dir locale-gen
    }

    # shellcheck disable=SC2317
    install_arch() {
        # 添加 swap
        create_swap_if_ram_less_than 1024 $os_dir/swapfile

        if false; then
            local alpine_rootfs=/
            apk add arch-install-scripts
        else
            local alpine_rootfs=$os_dir/alpine
            create_alpine_rootfs_with_arch_install_scripts "$alpine_rootfs" true "$os_dir"
        fi

        # 为了二次运行时 /etc/pacman.conf 未修改
        if [ -f $alpine_rootfs/etc/pacman.conf.orig ]; then
            cp $alpine_rootfs/etc/pacman.conf.orig $alpine_rootfs/etc/pacman.conf
        else
            cp $alpine_rootfs/etc/pacman.conf $alpine_rootfs/etc/pacman.conf.orig
        fi

        # 设置 repo
        insert_into_file $alpine_rootfs/etc/pacman.conf before '\[core\]' <<EOF
SigLevel = Never
ParallelDownloads = 5
EOF
        cat <<EOF >>$alpine_rootfs/etc/pacman.conf
[core]
Include = /etc/pacman.d/mirrorlist

[extra]
Include = /etc/pacman.d/mirrorlist
EOF
        mkdir -p $alpine_rootfs/etc/pacman.d
        # shellcheck disable=SC2016
        case "$(uname -m)" in
        x86_64) dir='$repo/os/$arch' ;;
        aarch64) dir='$arch/$repo' ;;
        esac
        # shellcheck disable=SC2154
        echo "Server = $mirror/$dir" >$alpine_rootfs/etc/pacman.d/mirrorlist

        # 安装系统
        # 要安装分区工具(包含 fsck.xxx)，用于 initramfs 检查分区数据
        pkgs="base grub openssh"

        # efi fs
        if is_efi; then
            pkgs="$pkgs efibootmgr dosfstools"
        fi

        # root fs
        case $(get_fs_of_mount_point "$os_dir") in
        xfs) pkgs="$pkgs xfsprogs" ;;
        ext4) pkgs="$pkgs e2fsprogs" ;;
        btrfs) pkgs="$pkgs btrfs-progs" ;;
        esac

        if [ "$(uname -m)" = aarch64 ]; then
            pkgs="$pkgs archlinuxarm-keyring"
        fi
        if ! [ "$username" = root ]; then
            pkgs="$pkgs sudo"
        fi

        # retry 防止网络问题
        if [ "$alpine_rootfs" = / ]; then
            retry 5 pacstrap -K "$os_dir" $pkgs
            killall -q gpg-agent || true
            apk del arch-install-scripts
        else
            retry 5 chroot "$alpine_rootfs" pacstrap -K "/parent" $pkgs
            killall -q gpg-agent || true
            umount -R "$alpine_rootfs/parent"
            remove_alpine_rootfs "$alpine_rootfs"
        fi

        # dns
        cp_resolv_conf $os_dir

        # 挂载伪文件系统
        mount_pseudo_fs $os_dir

        # 要先设置语言，再安装内核，不然出现
        # ==> Creating gzip-compressed initcpio image: '/boot/initramfs-linux.img'
        # bsdtar: bsdtar: Failed to set default locale
        # Failed to set default locale
        set_locale
        if [ "$(uname -m)" = aarch64 ]; then
            chroot $os_dir pacman-key --lsign-key builder@archlinuxarm.org
        fi

        # firmware + microcode
        if fw_pkgs=$(get_ucode_firmware_pkgs) && [ -n "$fw_pkgs" ]; then
            chroot $os_dir pacman -Syu --noconfirm $fw_pkgs
        fi

        # arm 的内核有多种选择，默认是 linux-aarch64，所以要添加 --noconfirm
        chroot $os_dir pacman -Syu --noconfirm linux
    }

    # shellcheck disable=SC2317
    install_gentoo() {
        # 添加 swap
        create_swap_if_ram_less_than 2048 $os_dir/swapfile

        # 解压系统
        apk add tar xz pv
        # shellcheck disable=SC2154
        download "$img" $os_dir/gentoo.tar.xz
        echo "Uncompressing Gentoo..."
        pv -f $os_dir/gentoo.tar.xz | tar xpJ --numeric-owner --xattrs-include='*.*' -C $os_dir
        rm $os_dir/gentoo.tar.xz
        apk del tar xz pv

        # dns
        cp_resolv_conf $os_dir

        # 挂载伪文件系统
        mount_pseudo_fs $os_dir

        # 下载仓库，选择 profile
        chroot $os_dir emerge-webrsync
        profile=$(
            # 筛选 stable systemd，再选择最短的
            if false; then
                chroot $os_dir eselect profile list | grep stable | grep systemd |
                    awk '(NR == 1 || length($2) < length(shortest)) { shortest = $2 } END { print shortest }'
            else
                chroot $os_dir eselect profile list | grep stable | grep systemd |
                    awk '{print length($2), $2}' | sort -n | head -1 | awk '{print $2}'
            fi
        )
        echo "Select profile: $profile"
        chroot $os_dir eselect profile set $profile

        # 设置 license
        cat <<EOF >>$os_dir/etc/portage/make.conf
ACCEPT_LICENSE="*"
EOF

        cat <<EOF >>$os_dir/etc/portage/make.conf
MAKEOPTS="-j$(get_build_threads 2048)"
EOF

        # 设置 http repo + binpkg repo
        # https://mirror.nju.edu.cn/gentoo/releases/amd64/autobuilds/current-stage3-amd64-systemd-mergedusr/stage3-amd64-systemd-mergedusr-20240317T170433Z.tar.xz
        mirror_short=$(echo "$img" | sed 's,/releases/.*,,')
        mirror_long=$(echo "$img" | sed 's,/autobuilds/.*,,')
        profile_ver=$(chroot $os_dir eselect profile show | grep -Eo '/[0-9.]*/' | cut -d/ -f2)

        if [ "$(uname -m)" = x86_64 ]; then
            if chroot $os_dir ld.so --help | grep supported | grep -q x86-64-v3; then
                binpkg_type=x86-64-v3
            else
                binpkg_type=x86-64
            fi
        else
            binpkg_type=arm64
        fi

        cat <<EOF >>$os_dir/etc/portage/make.conf
GENTOO_MIRRORS="$mirror_short"
FEATURES="getbinpkg"
EOF

        cat <<EOF >$os_dir/etc/portage/binrepos.conf/gentoobinhost.conf
[binhost]
priority = 9999
sync-uri = $mirror_long/binpackages/$profile_ver/$binpkg_type
EOF

        # 下载公钥

        # getuto 会判断是否有 ${TERM} 且 ${TERM} 不是 dumb
        # 符合条件则 source /lib/gentoo/functions.sh 导入 ebegin 等方法
        # 不符合条件则自行创建 ebegin 等方法

        # /lib/gentoo/functions.sh 会判断是否有 ${RC_OPENRC_PID}
        # 有的话就不会导入 /functions/openrc.sh，也就不会导入 ebegin 方法

        # 在 ssh 里运行 /trans.sh 时，没有 ${RC_OPENRC_PID}，${TERM} 是 xterm
        # 因此 chroot $os_dir getuto 时不会报错

        # 在 locald 里运行 /trans.sh 时，有 ${RC_OPENRC_PID}，${TERM} 是 linux
        # 因此 chroot $os_dir getuto 时会报错说 ebegin: command not found

        # 有两个解决方法
        if true; then
            TERM=dumb chroot $os_dir getuto
        else
            env -u RC_OPENRC_PID chroot $os_dir getuto
        fi

        set_locale

        # 安装 git 会升级 glibc，此时 /etc/locale.gen 不能为空，否则会提示生成所有 locale
        # Generating all locales; edit /etc/locale.gen to save time/space
        chroot $os_dir emerge dev-vcs/git

        # 设置 git repo
        if is_in_china; then
            git_uri=https://mirror.nju.edu.cn/git/gentoo-portage.git
        else
            # github 不支持 ipv6
            is_any_ipv4_has_internet && git_uri=https://github.com/gentoo-mirror/gentoo.git ||
                git_uri=https://anongit.gentoo.org/git/repo/gentoo.git
        fi

        mkdir -p $os_dir/etc/portage/repos.conf
        cat <<EOF >$os_dir/etc/portage/repos.conf/gentoo.conf
[gentoo]
location = /var/db/repos/gentoo
sync-type = git
sync-uri = $git_uri
EOF
        rm -rf $os_dir/var/db/repos/gentoo
        chroot $os_dir emerge --sync

        # 一次性安装所有包，可减少软件包重复 rebuild ?
        local pkgs=

        # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Tools#Filesystem_tools
        pkgs="$pkgs sys-block/io-scheduler-udev-rules"

        # efi fs
        if is_efi; then
            pkgs="$pkgs sys-fs/dosfstools sys-boot/efibootmgr"
        fi

        # root fs
        case $(get_fs_of_mount_point "$os_dir") in
        xfs) pkgs="$pkgs sys-fs/xfsprogs" ;;
        ext4) pkgs="$pkgs sys-fs/e2fsprogs" ;;
        btrfs) pkgs="$pkgs sys-fs/btrfs-progs" ;;
        esac

        # sudo
        if ! [ "$username" = root ]; then
            pkgs="$pkgs app-admin/sudo"
        fi

        # firmware + microcode
        if fw_pkgs=$(get_ucode_firmware_pkgs) && [ -n "$fw_pkgs" ]; then
            pkgs="$pkgs $fw_pkgs"
        fi

        # 安装 grub + 内核
        is_efi && grub_platforms="efi-64" || grub_platforms="pc"
        echo GRUB_PLATFORMS=\"$grub_platforms\" >>$os_dir/etc/portage/make.conf
        echo "sys-kernel/installkernel dracut grub" >$os_dir/etc/portage/package.use/installkernel

        # 要设置 root=UUID=xxxx，否则 dracut 会报错
        # 要注意 root=UUID=xxxx 头尾有空格
        # https://wiki.gentoo.org/wiki/Installkernel#Install_chroot_check
        # https://wiki.gentoo.org/wiki/Handbook:AMD64/Installation/Kernel#Chroot_detection
        uuid=$(chroot $os_dir findmnt -rno UUID /)
        mkdir -p $os_dir/etc/dracut.conf.d
        echo "kernel_cmdline=\" root=UUID=$uuid \"" >$os_dir/etc/dracut.conf.d/00-installkernel.conf
        pkgs="$pkgs sys-kernel/gentoo-kernel-bin"

        # 安装
        # 不添加 -n/--noreplace 的话会 rebuild 选定的包，无论是否已安装
        chroot "$os_dir" emerge -n $pkgs
    }

    install_aosc() {
        # 解压系统
        apk add wget tar xz
        wget "$img" -O- | tar xpJ --numeric-owner --xattrs-include='*.*' -C $os_dir
        apk del wget tar xz

        # 添加 swap
        create_swap_if_ram_less_than 1024 $os_dir/swapfile

        # 挂载伪文件系统
        mount_pseudo_fs $os_dir

        # 生成 initramfs
        chroot $os_dir update-initramfs
    }

    local os_dir=/os

    # 挂载分区
    mount_part_basic_layout /os /os/efi

    # 安装系统
    install_$distro

    # 安装 arch 有 gpg-agent 进程驻留
    killall -q gpg-agent || true

    # 初始化
    if false; then
        # preset-all 后多了很多服务，内存占用多了几十M
        chroot $os_dir systemctl preset-all
    fi

    # 网络配置
    case "$network_app" in
    systemd-networkd)
        chroot $os_dir systemctl enable systemd-networkd
        chroot $os_dir systemctl enable systemd-resolved

        apk add cloud-init
        # 第二次运行会报错
        useradd systemd-network || true
        create_cloud_init_network_config net.cfg
        cat -n net.cfg
        # 正常应该是 -D gentoo，但 alpine 的 cloud-init 包缺少 gentoo 配置
        cloud-init devel net-convert -p net.cfg -k yaml -d out -D alpine -O networkd

        # 注意名字是 10-cloud-init-eth*.network，fix-eth-name.sh 会此文件名查找配置文件
        cp out/etc/systemd/network/10-cloud-init-eth*.network $os_dir/etc/systemd/network/

        # 删除网卡名匹配
        sed -i '/^Name=/d' $os_dir/etc/systemd/network/10-cloud-init-eth*.network

        # 删除 Generated by cloud-init. Changes will be lost.
        # 并删除头部的空行
        sed -i '/^# Generated by cloud-init/d' $os_dir/etc/systemd/network/10-cloud-init-eth*.network
        del_head_empty_lines_inplace $os_dir/etc/systemd/network/10-cloud-init-eth*.network

        # 清理
        rm -rf net.cfg out
        apk del cloud-init

        # 显示网络配置
        cat -n $os_dir/etc/systemd/network/10-cloud-init-eth*.network
        ;;
    network-manager)
        chroot $os_dir systemctl enable NetworkManager

        # 可以直接用 alpine 的 cloud-init 生成 Network Manager 配置
        create_cloud_init_network_config /net.cfg
        create_network_manager_config /net.cfg "$os_dir"
        rm /net.cfg
        ;;
    esac

    # arch gentoo 网络配置是用 alpine cloud-init 生成的
    # cloud-init 版本够新，因此无需修复 onlink 网关

    basic_init $os_dir

    # ntp 用 systemd 自带的
    # TODO: vm agent + 随机数生成器

    # grub
    if is_efi; then
        # arch gentoo 推荐 efi 挂载在 /efi
        chroot $os_dir grub-install --efi-directory=/efi
        chroot $os_dir grub-install --efi-directory=/efi --removable
    else
        chroot $os_dir grub-install /dev/$xda
    fi

    # cmdline + 生成 grub.cfg
    if [ -d $os_dir/etc/default/grub.d ]; then
        file=$os_dir/etc/default/grub.d/tty.cfg
    else
        file=$os_dir/etc/default/grub
    fi
    ttys_cmdline=$(get_ttys console=)
    echo GRUB_CMDLINE_LINUX=\"\$GRUB_CMDLINE_LINUX $ttys_cmdline\" >>$file
    chroot $os_dir grub-mkconfig -o /boot/grub/grub.cfg

    # fstab
    # fstab 可不写 efi 条目， systemd automount 会自动挂载
    # fstab 头部有使用说明，因此用 >>
    local alpine_rootfs=$os_dir/alpine
    create_alpine_rootfs_with_arch_install_scripts "$alpine_rootfs" true "$os_dir"
    # genfstab 会用到 findmnt 等工具
    retry 5 chroot "$alpine_rootfs" apk add util-linux
    chroot "$alpine_rootfs" genfstab -U /parent | sed '/swap/d' >>$os_dir/etc/fstab
    umount -R "$alpine_rootfs/parent"
    remove_alpine_rootfs "$alpine_rootfs"

    # 删除 resolv.conf，不然 systemd-resolved 无法创建软链接
    rm_resolv_conf $os_dir

    # 删除 swap
    swapoff -a
    rm -rf $os_dir/swapfile
}

get_http_file_size() {
    url=$1

    # 网址重定向可能得到多个 Content-Length, 选最后一个
    wget --spider -S "$url" 2>&1 | grep 'Content-Length:' |
        tail -1 | awk '{print $2}' | grep .
}

get_url_hash() {
    url=$1

    echo "$url" | md5sum | awk '{print $1}'
}

aria2c() {
    if ! is_have_cmd aria2c; then
        apk add aria2
    fi

    # stdbuf 在 coreutils 包里面
    if ! is_have_cmd stdbuf; then
        apk add coreutils
    fi

    # 显示 url
    show_url_in_args "$@" >&2

    # 下载 tracker
    # 在 sub shell 里面无法保存变量，因此写入到文件
    if echo "$@" | grep -Eq 'magnet:|\.torrent' && ! [ -f "/tmp/trackers" ]; then
        # 独自一行下载，不然下载失败不会报错
        # 里面有空行
        # txt=$(wget -O- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt | grep .)
        # txt=$(wget -O- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt | grep .)
        txt=$(wget -O- https://cf.trackerslist.com/best.txt | grep .)
        # sed 删除最后一个逗号
        echo "$txt" | newline_to_comma | sed 's/,$//' >/tmp/trackers
    fi

    # --dht-entry-point=router.bittorrent.com:6881 \
    # --dht-entry-point=dht.transmissionbt.com:6881 \
    # --dht-entry-point=router.utorrent.com:6881 \
    retry 5 5 stdbuf -oL -eL aria2c \
        -x4 \
        --seed-time=0 \
        --allow-overwrite=true \
        --summary-interval=0 \
        --max-tries 1 \
        --bt-tracker="$([ -f "/tmp/trackers" ] && cat /tmp/trackers)" \
        "$@"
}

download_torrent_by_magnet() {
    url=$1
    dst=$2

    url_hash=$(get_url_hash "$url")

    mkdir -p /tmp/bt/$url_hash

    # 不支持 -o bt.torrent 指定文件名
    aria2c "$url" \
        --bt-metadata-only=true \
        --bt-save-metadata=true \
        -d /tmp/bt/$url_hash

    mv /tmp/bt/$url_hash/*.torrent "$dst"
    rm -rf /tmp/bt/$url_hash
}

get_torrent_path_by_magnet() {
    echo "/tmp/bt/$(get_url_hash "$1").torrent"
}

get_bt_file_size() {
    url=$1

    torrent="$(get_torrent_path_by_magnet $url)"
    download_torrent_by_magnet "$url" "$torrent" >&2

    # 列出第一个文件的大小
    # idx|path/length
    # ===+===========================================================================
    #   1|./zh-cn_windows_11_consumer_editions_version_24h2_updated_jan_2025_x64_dvd_7a8e5a29.iso
    #    |6.1GiB (6,557,558,784)

    aria2c --show-files=true "$torrent" |
        grep -F -A1 '  1|./' | tail -1 | grep -o '(.*)' | sed -E 's/[(),]//g' | grep .
}

get_link_file_size() {
    if is_magnet_link "$1" >&2; then
        get_bt_file_size "$1"
    else
        get_http_file_size "$1"
    fi
}

pipe_extract() {
    # alpine busybox 自带 gzip，但官方版也许性能更好
    case "$img_type_warp" in
    xz | gzip | zstd)
        apk add $img_type_warp
        "$img_type_warp" -dc
        ;;
    tar)
        apk add tar
        tar x -O
        ;;
    tar.*)
        type=$(echo "$img_type_warp" | cut -d. -f2)
        apk add tar "$type"
        tar x "--$type" -O
        ;;
    '') cat ;;
    *) error_and_exit "Not supported img_type_warp: $img_type_warp" ;;
    esac
}

dd_raw_with_extract() {
    info "dd raw"

    # 用官方 wget，一来带进度条，二来自带重试功能
    apk add wget

    if ! wget $img -O- | pipe_extract >/dev/$xda 2>/tmp/dd_stderr; then
        # vhd 文件结尾有 512 字节额外信息，可以忽略
        if grep -iq 'No space' /tmp/dd_stderr; then
            apk add parted
            disk_size=$(get_disk_size /dev/$xda)
            disk_end=$((disk_size - 1))

            # 如果报错，那大概是因为镜像比硬盘大
            if last_part_end=$(parted -sf /dev/$xda 'unit b print' ---pretend-input-tty |
                del_empty_lines | tail -1 | awk '{print $3}' | sed 's/B//' | grep .); then

                echo "Last part end: $last_part_end"
                echo "Disk end:      $disk_end"

                if [ "$last_part_end" -le "$disk_end" ]; then
                    echo "Safely ignore no space error."
                    return
                fi
            fi
        fi
        error_and_exit "$(cat /tmp/dd_stderr)"
    fi
}

get_disk_sector_count() {
    # cat /proc/partitions
    blockdev --getsz "$1"
}

get_disk_size() {
    blockdev --getsize64 "$1"
}

get_disk_logic_sector_size() {
    blockdev --getss "$1"
}

is_4kn() {
    [ "$(blockdev --getss "/dev/$xda")" = 4096 ]
}

is_xda_gt_2t() {
    disk_size=$(get_disk_size /dev/$xda)
    disk_2t=$((2 * 1024 * 1024 * 1024 * 1024))
    [ "$disk_size" -gt "$disk_2t" ]
}

is_ends_with_digit() {
    [[ "$1" =~ [0-9]$ ]]
}

xda() {
    if [ -n "$1" ]; then
        if is_ends_with_digit "$xda"; then
            echo "${xda}p$1"
        else
            echo "${xda}$1"
        fi
    else
        echo "$xda"
    fi
}

create_part() {
    # 除了 dd 都会用到
    info "Create Part"

    # 分区工具
    apk add parted e2fsprogs
    if is_efi; then
        apk add dosfstools
    fi

    # 清除分区表
    # https://github.com/bin456789/reinstall/issues/638
    apk add wipefs
    wipefs -a -f /dev/$xda
    apk del wipefs

    # shellcheck disable=SC2154
    if [ "$distro" = windows ]; then
        if ! size_bytes=$(get_link_file_size "$iso"); then
            # 默认值，目前最大的 iso 小于 10g
            size_bytes=$((10 * 1024 * 1024 * 1024))
        fi

        # 按iso容量计算分区大小
        # 200m 用于驱动/文件系统自身占用 + pagefile
        # 理论上 installer 分区可以删除 boot.wim，这样就不用额外添加 200m，但是
        # 1. vista/2008 不能删除 boot.wim
        # 2. 下载镜像前不知道是 vista/2008，因为 --image-name 可以随便输入
        # 因此还是要额外添加 200m
        # 注意这里单位要用 MiB，因为后面的 border 要以 MiB 计算
        part_size="$((size_bytes / 1024 / 1024 + 200))MiB"

        apk add ntfs-3g-progs
        # 虽然ntfs3不需要fuse，但wimmount需要，所以还是要保留
        modprobe fuse ntfs3
        if is_efi; then
            # efi
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart '" "' fat32 1MiB 1025MiB \
                mkpart '" "' fat32 1025MiB 1041MiB \
                mkpart '" "' ntfs 1041MiB -${part_size} \
                mkpart '" "' ntfs -${part_size} 100% \
                set 1 boot on \
                set 2 msftres on \
                set 3 msftdata on
            update_part

            mkfs.fat -n efi "/dev/$(xda 1)"                   #1 efi
            dd if=/dev/zero of="/dev/$(xda 2)" bs=1M count=16 #2 msr
            mkfs.ntfs -f -F -L os "/dev/$(xda 3)"             #3 os
            mkfs.ntfs -f -F -L installer "/dev/$(xda 4)"      #4 installer
        else
            # bios + mbr 启动盘最大可用 2t
            if is_xda_gt_2t; then
                border=$((2 * 1024 * 1024 - ${part_size%MiB}))MiB
                max_usable_size=2TiB
            else
                border=-${part_size}
                max_usable_size=100%
            fi
            parted /dev/$xda -s -- \
                mklabel msdos \
                mkpart primary ntfs 1MiB ${border} \
                mkpart primary ntfs ${border} ${max_usable_size} \
                set 1 boot on
            update_part

            mkfs.ntfs -f -F -L os "/dev/$(xda 1)"        #1 os
            mkfs.ntfs -f -F -L installer "/dev/$(xda 2)" #2 installer
        fi
    elif [ "$distro" = fnos ]; then
        # 1. 官方安装器对系统盘大小的定义包含引导分区大小
        # 2. 官方 efi 用的是 1MiB-100M，但我们用 1MiB-101MiB

        # 预期的系统分区大小，包括引导的 1M + 100M 的引导分区
        expect_m=$((${fnos_part_size%[Gg]} * 1024))

        sector_size=$(get_disk_logic_sector_size /dev/$xda)
        total_sector_count=$(get_disk_sector_count /dev/$xda)

        # 截止最后一个分区的总扇区数（也就是总硬盘扇区数 - 备份分区表扇区数 - 备份 GPT Header）
        if ! is_efi && ! is_xda_gt_2t; then
            # mbr
            total_sector_count_except_backup_gpt=$total_sector_count
        elif is_4kn; then
            total_sector_count_except_backup_gpt=$((total_sector_count - 4 - 1))
        else
            total_sector_count_except_backup_gpt=$((total_sector_count - 32 - 1))
        fi

        # 向下取整 MiB
        # gpt 最后 33 (512n/512e) 或 5 (4Kn) 个扇区是备份分区表，不可用
        # parted 结束位置填 100% 时也会忽略最后不足 1MiB 的部分，我们模仿它
        max_can_use_m=$((total_sector_count_except_backup_gpt * sector_size / 1024 / 1024))

        echo "expect_m: $expect_m"
        echo "max_can_use_m: $max_can_use_m"

        # 20G 的硬盘，即使用 msdos 分区表，parted 也不接受 part end 为 20480MiB，因此要用 100%
        # The location 20480MiB is outside of the device /dev/vda.
        # 但是 100% 分区后 end 就是 20480MiB

        if [ "$expect_m" -ge "$max_can_use_m" ]; then
            warn "Expect size is equal/greater than max size. Uses max size."
            NEED_SHRINK_FNOS_OS_PART=false
            FNOS_OS_PART_END_M=$max_can_use_m
        else
            NEED_SHRINK_FNOS_OS_PART=true
            FNOS_OS_PART_END_M=$expect_m
        fi

        # fnos 的 grub 是 debian 11 的
        # 需关闭 metadata_csum_seed，否则 grub 会进入 grub rescue 模式，但 efi 下一切正常
        # orphan_file 不需要关，但是官方安装器安装的系统分区没有这个特性，因此我们也关闭它
        ext4_opts="-O ^metadata_csum_seed,^orphan_file"

        if is_efi; then
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart BOOT fat32 1MiB 101MiB \
                mkpart SYSTEM ext4 101MiB 100% \
                set 1 esp on
            update_part

            mkfs.fat "/dev/$(xda 1)"                #1 efi
            mkfs.ext4 -F $ext4_opts "/dev/$(xda 2)" #2 os + installer
        elif is_xda_gt_2t; then
            # bios > 2t
            # 官方安装器是 mkpart BOOT 1M 100M，无论 esp 或者 bios_grub 都用这个分区和大小
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart BOOT ext4 1MiB 101MiB \
                mkpart SYSTEM ext4 101MiB 100% \
                set 1 bios_grub on
            update_part

            echo                                    #1 bios_boot
            mkfs.ext4 -F $ext4_opts "/dev/$(xda 2)" #2 os + installer
        else
            # bios
            parted /dev/$xda -s -- \
                mklabel msdos \
                mkpart primary 1MiB 101MiB \
                mkpart primary 101MiB 100% \
                set 2 boot on
            update_part

            echo                                    #1 官方安装有这个分区
            mkfs.ext4 -F $ext4_opts "/dev/$(xda 2)" #2 os + installer
        fi
    elif is_use_cloud_image; then
        installer_part_size="$(get_cloud_image_part_size)"
        # 这几个系统不使用dd，而是复制文件
        if [ "$distro" = centos ] || [ "$distro" = almalinux ] || [ "$distro" = rocky ] ||
            [ "$distro" = oracle ] || [ "$distro" = redhat ] ||
            [ "$distro" = anolis ] || [ "$distro" = opencloudos ] || [ "$distro" = openeuler ] ||
            [ "$distro" = ubuntu ]; then
            # 这里的 fs 没有用，最终使用目标系统的格式化工具
            fs=ext4
            if is_efi; then
                parted /dev/$xda -s -- \
                    mklabel gpt \
                    mkpart '" "' fat32 1MiB 101MiB \
                    mkpart '" "' $fs 101MiB -$installer_part_size \
                    mkpart '" "' ext4 -$installer_part_size 100% \
                    set 1 esp on
                update_part

                mkfs.fat -n efi "/dev/$(xda 1)"           #1 efi
                echo                                      #2 os 用目标系统的格式化工具
                mkfs.ext4 -F -L installer "/dev/$(xda 3)" #3 installer
            else
                parted /dev/$xda -s -- \
                    mklabel gpt \
                    mkpart '" "' ext4 1MiB 2MiB \
                    mkpart '" "' $fs 2MiB -$installer_part_size \
                    mkpart '" "' ext4 -$installer_part_size 100% \
                    set 1 bios_grub on
                update_part

                echo                                      #1 bios_boot
                echo                                      #2 os 用目标系统的格式化工具
                mkfs.ext4 -F -L installer "/dev/$(xda 3)" #3 installer
            fi
        else
            # 使用 dd qcow2
            # fedora debian opensuse arch gentoo
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart '" "' ext4 1MiB -$installer_part_size \
                mkpart '" "' ext4 -$installer_part_size 100%
            update_part

            mkfs.ext4 -F -L os "/dev/$(xda 1)"        #1 os
            mkfs.ext4 -F -L installer "/dev/$(xda 2)" #2 installer
        fi
    elif [ "$distro" = alpine ] || [ "$distro" = arch ] || [ "$distro" = gentoo ] ||
        [ "$distro" = nixos ] || [ "$distro" = aosc ]; then
        # alpine 本身关闭了 64bit ext4
        # https://gitlab.alpinelinux.org/alpine/alpine-conf/-/blob/3.18.1/setup-disk.in?ref_type=tags#L908
        # 而且 alpine 的 extlinux 不兼容 64bit ext4
        [ "$distro" = alpine ] && ext4_opts="-O ^64bit" || ext4_opts=
        if is_efi; then
            # efi
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart '" "' fat32 1MiB 101MiB \
                mkpart '" "' ext4 101MiB 100% \
                set 1 boot on
            update_part

            mkfs.fat "/dev/$(xda 1)"                #1 efi
            mkfs.ext4 -F $ext4_opts "/dev/$(xda 2)" #2 os
        elif is_xda_gt_2t; then
            # bios > 2t
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart '" "' ext4 1MiB 2MiB \
                mkpart '" "' ext4 2MiB 100% \
                set 1 bios_grub on
            update_part

            echo                                    #1 bios_boot
            mkfs.ext4 -F $ext4_opts "/dev/$(xda 2)" #2 os
        else
            # bios
            parted /dev/$xda -s -- \
                mklabel msdos \
                mkpart primary ext4 1MiB 100% \
                set 1 boot on
            update_part

            mkfs.ext4 -F $ext4_opts "/dev/$(xda 1)" #1 os
        fi
    else
        # 安装红帽系或ubuntu
        # 对于红帽系是临时分区表，安装时除了 installer 分区，其他分区会重建为默认的大小
        # 对于ubuntu是最终分区表，因为 ubuntu 的安装器不能调整个别分区，只能重建整个分区表
        # installer 2g分区用fat格式刚好塞得下ubuntu-22.04.3 iso，而ext4塞不下或者需要改参数
        if [ "$distro" = ubuntu ]; then
            if ! size_bytes=$(get_http_file_size "$iso"); then
                # 默认值，假设 iso 3g
                size_bytes=$((3 * 1024 * 1024 * 1024))
            fi
            installer_part_size="$(get_part_size_mb_for_file_size_b $size_bytes)MiB"
        else
            # redhat
            installer_part_size=2GiB
        fi

        # centos 7 无法加载alpine格式化的ext4
        # 要关闭这个属性
        ext4_opts="-O ^metadata_csum"
        apk add dosfstools

        if is_efi; then
            # efi
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart '" "' fat32 1MiB 1025MiB \
                mkpart '" "' ext4 1025MiB -$installer_part_size \
                mkpart '" "' ext4 -$installer_part_size 100% \
                set 1 boot on
            update_part

            mkfs.fat -n efi "/dev/$(xda 1)"                      #1 efi
            mkfs.ext4 -F -L os "/dev/$(xda 2)"                   #2 os
            mkfs.ext4 -F -L installer $ext4_opts "/dev/$(xda 3)" #2 installer
        elif is_xda_gt_2t; then
            # bios > 2t
            parted /dev/$xda -s -- \
                mklabel gpt \
                mkpart '" "' ext4 1MiB 2MiB \
                mkpart '" "' ext4 2MiB -$installer_part_size \
                mkpart '" "' ext4 -$installer_part_size 100% \
                set 1 bios_grub on
            update_part

            echo                                                 #1 bios_boot
            mkfs.ext4 -F -L os "/dev/$(xda 2)"                   #2 os
            mkfs.ext4 -F -L installer $ext4_opts "/dev/$(xda 3)" #3 installer
        else
            # bios
            parted /dev/$xda -s -- \
                mklabel msdos \
                mkpart primary ext4 1MiB -$installer_part_size \
                mkpart primary ext4 -$installer_part_size 100% \
                set 1 boot on
            update_part

            mkfs.ext4 -F -L os "/dev/$(xda 1)"                   #1 os
            mkfs.ext4 -F -L installer $ext4_opts "/dev/$(xda 2)" #2 installer
        fi
        update_part
    fi

    update_part

    # alpine 删除分区工具，防止 256M 小机爆内存
    # setup-disk /dev/sda 会保留格式化工具，我们也保留
    if [ "$distro" = alpine ]; then
        apk del parted
    fi
}

umount_pseudo_fs() {
    local os_dir
    os_dir=$(realpath "$1")

    dirs="/proc /sys /dev /run"
    regex=$(echo "$dirs" | sed 's, ,|,g')
    if mounts=$(mount | grep -Ew "on $os_dir($regex)" | awk '{print $3}' | tac); then
        for mount in $mounts; do
            echo "umount $mount"
            umount $mount
        done
    fi
}

mount_pseudo_fs() {
    local os_dir=$1

    mkdir -p $os_dir/proc/ $os_dir/sys/ $os_dir/dev/ $os_dir/run/

    # https://wiki.archlinux.org/title/Chroot#Using_chroot
    mount -t proc /proc $os_dir/proc/
    mount -t sysfs /sys $os_dir/sys/
    mount --rbind /dev $os_dir/dev/
    mount --rbind /run $os_dir/run/
    if is_efi; then
        mount --rbind /sys/firmware/efi/efivars $os_dir/sys/firmware/efi/efivars/
    fi
}

create_cloud_init_network_config() {
    ci_file=$1
    recognize_static6=${2:-true}
    recognize_ipv6_types=${3:-true}

    info "Create Cloud-init network config"

    # 防止文件未创建
    mkdir -p "$(dirname "$ci_file")"
    touch "$ci_file"

    apk add yq-go

    need_set_dns4=false
    need_set_dns6=false

    config_id=0
    for ethx in $(get_eths); do
        get_netconf_to mac_addr

        # shellcheck disable=SC2154
        yq -i ".network.version=1 |
           .network.config[$config_id].type=\"physical\" |
           .network.config[$config_id].name=\"$ethx\" |
           .network.config[$config_id].mac_address=(\"$mac_addr\" | . style=\"single\")
           " $ci_file

        subnet_id=0

        # ipv4
        if is_dhcpv4; then
            yq -i ".network.config[$config_id].subnets[$subnet_id] = {\"type\": \"dhcp4\"}" $ci_file
            subnet_id=$((subnet_id + 1))
        elif is_staticv4; then
            need_set_dns4=true
            get_netconf_to ipv4_addr
            get_netconf_to ipv4_gateway
            yq -i ".network.config[$config_id].subnets[$subnet_id] = {
                    \"type\": \"static\",
                    \"address\": \"$ipv4_addr\",
                    \"gateway\": \"$ipv4_gateway\" }
                    " $ci_file

            # 旧版 cloud-init 有 bug
            # 有的版本会只从第一种配置中读取 dns，有的从第二种读取
            # 因此写两种配置
            # https://github.com/canonical/cloud-init/commit/1b8030e0c7fd6fbff7e38ad1e3e6266ae50c83a5
            for cur in $(get_current_dns 4); do
                yq -i ".network.config[$config_id].subnets[$subnet_id].dns_nameservers += [\"$cur\"]" $ci_file
            done
            subnet_id=$((subnet_id + 1))
        fi

        # ipv6
        # slaac:  ipv6_slaac
        # └─enable_other_flag: ipv6_dhcpv6-stateless
        # dhcpv6: ipv6_dhcpv6-stateful

        # ipv6
        if is_slaac; then
            if $recognize_ipv6_types; then
                if is_enable_other_flag; then
                    type=ipv6_dhcpv6-stateless
                else
                    type=ipv6_slaac
                fi
            else
                type=dhcp6
            fi
            yq -i ".network.config[$config_id].subnets[$subnet_id] = {\"type\": \"$type\"}" $ci_file

        elif is_dhcpv6; then
            if $recognize_ipv6_types; then
                type=ipv6_dhcpv6-stateful
            else
                type=dhcp6
            fi
            yq -i ".network.config[$config_id].subnets[$subnet_id] = {\"type\": \"$type\"}" $ci_file

        elif is_staticv6; then
            get_netconf_to ipv6_addr
            get_netconf_to ipv6_gateway
            if $recognize_static6; then
                type_ipv6_static=static6
            else
                type_ipv6_static=static
            fi
            yq -i ".network.config[$config_id].subnets[$subnet_id] = {
                    \"type\": \"$type_ipv6_static\",
                    \"address\": \"$ipv6_addr\",
                    \"gateway\": \"$ipv6_gateway\" }
                    " $ci_file
        fi
        # 无法设置 autoconf = false ?
        if should_disable_accept_ra; then
            yq -i ".network.config[$config_id].accept-ra = false" $ci_file
        fi

        # 有 ipv6 但需设置 dns 的情况
        if is_need_manual_set_dnsv6; then
            need_set_dns6=true
            for cur in $(get_current_dns 6); do
                yq -i ".network.config[$config_id].subnets[$subnet_id].dns_nameservers += [\"$cur\"]" $ci_file
            done
        fi

        config_id=$((config_id + 1))
    done

    if $need_set_dns4 || $need_set_dns6; then
        yq -i ".network.config[$config_id].type=\"nameserver\"" $ci_file
        if $need_set_dns4; then
            for cur in $(get_current_dns 4); do
                yq -i ".network.config[$config_id].address += [\"$cur\"]" $ci_file
            done
        fi
        if $need_set_dns6; then
            for cur in $(get_current_dns 6); do
                yq -i ".network.config[$config_id].address += [\"$cur\"]" $ci_file
            done
        fi
        # 如果 network.config[$config_id] 没有 address，则删除，避免低版本 cloud-init 报错
        yq -i "del(.network.config[$config_id] | select(has(\"address\") | not))" $ci_file
    fi

    apk del yq-go

    # 查看文件
    info "Cloud-init network config"
    cat -n $ci_file >&2
}

# 实测没用，生成的 machine-id 是固定的
# 而且 lightsail centos 9 模板 machine-id 也是相同的，显然相同 id 不是个问题
clear_machine_id() {
    local os_dir=$1

    # https://www.freedesktop.org/software/systemd/man/latest/machine-id.html
    # gentoo 不会自动创建该文件
    echo uninitialized >$os_dir/etc/machine-id

    # https://build.opensuse.org/projects/Virtualization:Appliances:Images:openSUSE-Leap-15.5/packages/kiwi-templates-Minimal/files/config.sh?expand=1
    rm -f $os_dir/var/lib/systemd/random-seed
}

# 注意 anolis 7 有这个文件，可能干扰我们的配置?
# /etc/cloud/cloud.cfg.d/aliyun_cloud.cfg -> /sys/firmware/qemu_fw_cfg/by_name/etc/cloud-init/vendor-data/raw
download_cloud_init_config() {
    local os_dir=$1
    recognize_static6=$2
    recognize_ipv6_types=$3

    ci_file=$os_dir/etc/cloud/cloud.cfg.d/99_fallback.cfg
    download $confhome/deprecated/cloud-init.yaml $ci_file
    # 删除注释行，除了第一行
    sed -i '1!{/^[[:space:]]*#/d}' $ci_file

    # 修改密码
    # 不能用 sed 替换，因为含有特殊字符
    content=$(cat $ci_file)
    echo "${content//@PASSWORD@/$(get_password_linux_sha512)}" >$ci_file

    # 修改 ssh 端口
    if is_need_change_ssh_port; then
        sed -i "s/@SSH_PORT@/$ssh_port/g" $ci_file
    else
        sed -i "/@SSH_PORT@/d" $ci_file
    fi

    # swapfile
    # 如果分区表中已经有swapfile就跳过，例如arch
    if ! grep -w swap $os_dir/etc/fstab; then
        cat <<EOF >>$ci_file
swap:
  filename: /swapfile
  size: auto
EOF
    fi

    create_cloud_init_network_config "$ci_file" "$recognize_static6" "$recognize_ipv6_types"
}

get_image_state() {
    local os_dir=$1
    local image_state=

    # 如果 dd 镜像精简了 State.ini，则从注册表获取
    if state_ini=$(find_file_ignore_case $os_dir/Windows/Setup/State/State.ini); then
        image_state=$(grep -i '^ImageState=' $state_ini | cut -d= -f2 | tr -d '\r')
    fi
    if [ -z "$image_state" ]; then
        apk add hivex-perl
        hive=$(find_file_ignore_case $os_dir/Windows/System32/config/SOFTWARE)
        image_state=$(hivexget $hive '\Microsoft\Windows\CurrentVersion\Setup\State' ImageState)
        apk del hivex-perl
    fi

    if [ -n "$image_state" ]; then
        echo "$image_state"
    else
        error_and_exit "Cannot get ImageState."
    fi
}

modify_windows() {
    local os_dir=$1
    info "Modify Windows"

    # https://learn.microsoft.com/windows-hardware/manufacture/desktop/windows-setup-states
    # https://learn.microsoft.com/troubleshoot/azure/virtual-machines/reset-local-password-without-agent
    # https://learn.microsoft.com/windows-hardware/manufacture/desktop/add-a-custom-script-to-windows-setup

    # 判断用 SetupComplete 还是组策略
    image_state=$(get_image_state "$os_dir")
    echo "ImageState: $image_state"

    if [ "$image_state" = IMAGE_STATE_COMPLETE ]; then
        use_gpo=true
    else
        use_gpo=false
    fi

    # bat 列表
    bats=

    # 1. rdp 端口
    if is_need_change_rdp_port; then
        create_win_change_rdp_port_script $os_dir/windows-change-rdp-port.bat "$rdp_port"
        bats="$bats windows-change-rdp-port.bat"
    fi

    # 2. 允许 ping
    if is_allow_ping; then
        download $confhome/windows-allow-ping.bat $os_dir/windows-allow-ping.bat
        bats="$bats windows-allow-ping.bat"
    fi

    # 3. 合并分区
    # 可能 unattend.xml 已经设置了ExtendOSPartition，不过运行resize没副作用
    download $confhome/windows-resize.bat $os_dir/windows-resize.bat
    bats="$bats windows-resize.bat"

    # 4. 网络设置
    for ethx in $(get_eths); do
        create_win_set_netconf_script $os_dir/windows-set-netconf-$ethx.bat
        bats="$bats windows-set-netconf-$ethx.bat"
    done

    # 5. 设置用户密码永不过期（仅限 iso 安装）
    #    Azure 的 Windows 实例，初始用户的密码也是永不过期的
    #    管理员账号默认不会过期
    if [ "$distro" = "windows" ] && ! is_administrator_username "$username"; then
        # 两种方法都可以，但语法很神奇

        # 第二行前面不能有空格
        cat <<EOF >$os_dir/windows-set-user-password-never-expires.bat
wmic useraccount where name="$username" set passwordexpires=false || ^
powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Set-LocalUser -Name '$username' -PasswordNeverExpires \$true"
del "%~f0"
EOF
        # 第二行 || 前面必须有空格
        cat <<EOF >$os_dir/windows-set-user-password-never-expires.bat
wmic useraccount where name="$username" set passwordexpires=false ^
  || powershell -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "Set-LocalUser -Name '$username' -PasswordNeverExpires \$true"
del "%~f0"
EOF
        unix2dos $os_dir/windows-set-user-password-never-expires.bat
        bats="$bats windows-set-user-password-never-expires.bat"
    fi

    # 6. frp
    if ls /configs/frpc.* >/dev/null 2>&1; then
        if [ "$(get_windows_arch_from_windows_drive "$os_dir" | to_lower)" = x86 ]; then
            os_bit=32
        else
            os_bit=64
        fi
        mkdir -p "$os_dir/frpc/"
        url=$(get_frpc_url windows "$nt_ver" "$os_bit")
        download "$url" $os_dir/frpc/frpc.zip
        # -j 去除文件夹
        # -C 筛选文件时不区分大小写，但 busybox zip 不支持
        unzip -o -j "$os_dir/frpc/frpc.zip" '*/frpc.exe' -d "$os_dir/frpc/"
        rm -f "$os_dir/frpc/frpc.zip"
        cp -f /configs/frpc.* "$os_dir/frpc/"
        download "$confhome/windows-frpc.xml" "$os_dir/frpc/frpc.xml"
        download "$confhome/windows-frpc.bat" "$os_dir/frpc/frpc.bat"
        bats="$bats frpc\frpc.bat"
    fi

    if $use_gpo; then
        # 使用组策略
        scripts_ini=$(get_path_in_correct_case $os_dir/Windows/System32/GroupPolicy/Machine/Scripts/scripts.ini)
        mkdir -p "$(dirname $scripts_ini)"
        gpt_ini=$(get_path_in_correct_case $os_dir/Windows/System32/GroupPolicy/gpt.ini)

        # 备份 ini
        for file in $gpt_ini $scripts_ini; do
            if [ -f $file ]; then
                cp $file $file.orig
            fi
        done

        # gpt.ini
        cat >$gpt_ini <<EOF
[General]
gPCFunctionalityVersion=2
gPCMachineExtensionNames=[{42B5FAAE-6536-11D2-AE5A-0000F87571E3}{40B6664F-4972-11D1-A7CA-0000F87571E3}]
Version=1
EOF
        unix2dos $gpt_ini

        # scripts.ini
        if ! [ -e $scripts_ini ]; then
            touch $scripts_ini
        fi

        if ! grep -F '[Startup]' $scripts_ini; then
            echo '[Startup]' >>$scripts_ini
        fi

        # 注意没用 pipefail 的话，错误码取自最后一个管道
        if num=$(grep -Eo '^[0-9]+' $scripts_ini | sort -n | tail -1 | grep .); then
            num=$((num + 1))
        else
            num=0
        fi

        bats="$bats windows-del-gpo.bat"
        for bat in $bats; do
            echo "${num}CmdLine=%SystemDrive%\\$bat" >>$scripts_ini
            echo "${num}Parameters=" >>$scripts_ini
            num=$((num + 1))
        done
        cat $scripts_ini
        unix2dos $scripts_ini

        # windows-del-gpo.bat
        download $confhome/windows-del-gpo.bat $os_dir/windows-del-gpo.bat
    else
        # 使用 SetupComplete
        setup_complete=$(get_path_in_correct_case $os_dir/Windows/Setup/Scripts/SetupComplete.cmd)
        mkdir -p "$(dirname $setup_complete)"

        # 添加到 C:\Setup\Scripts\SetupComplete.cmd 最前面
        # call 防止子 bat 删除自身后中断主脚本
        setup_complete_mod=$(mktemp)
        for bat in $bats; do
            echo "if exist %SystemDrive%\\$bat (call %SystemDrive%\\$bat)" >>$setup_complete_mod
        done

        # 复制原来的内容
        if [ -f $setup_complete ]; then
            cat $setup_complete >>$setup_complete_mod
        fi

        unix2dos $setup_complete_mod

        # cat 可以保留权限
        cat $setup_complete_mod >$setup_complete

        # 查看最终内容
        cat -n $setup_complete
    fi
}

get_axx64() {
    case "$(uname -m)" in
    x86_64) echo amd64 ;;
    aarch64) echo arm64 ;;
    esac
}

is_file_or_link() {
    # -e / -f 坏软连接，返回 false
    # -L 坏软连接，返回 true
    [ -f $1 ] || [ -L $1 ]
}

cp_resolv_conf() {
    local os_dir=$1
    if is_file_or_link $os_dir/etc/resolv.conf &&
        ! is_file_or_link $os_dir/etc/resolv.conf.orig; then
        mv $os_dir/etc/resolv.conf $os_dir/etc/resolv.conf.orig
    fi
    cp -f /etc/resolv.conf $os_dir/etc/resolv.conf
}

rm_resolv_conf() {
    local os_dir=$1
    rm -f $os_dir/etc/resolv.conf $os_dir/etc/resolv.conf.orig
}

restore_resolv_conf() {
    local os_dir=$1
    if is_file_or_link $os_dir/etc/resolv.conf.orig; then
        mv -f $os_dir/etc/resolv.conf.orig $os_dir/etc/resolv.conf
    fi
}

keep_now_resolv_conf() {
    local os_dir=$1
    rm -f $os_dir/etc/resolv.conf.orig
}

# 抄 https://github.com/alpinelinux/alpine-conf/blob/3.18.1/setup-disk.in#L421
get_alpine_firmware_pkgs() {
    # 需要有 modloop，不然 modinfo 会报错
    ensure_service_started modloop >&2

    # 如果不在单独的文件夹，则用 linux-firmware-other
    # 如果在单独的文件夹，则用 linux-firmware-xxx
    # 如果不需要 firmware，则用 linux-firmware-none
    firmware_pkgs=$(
        cd /sys/module && modinfo -F firmware -- * 2>/dev/null |
            awk -F/ '{print $1 == $0 ? "linux-firmware-other" : "linux-firmware-"$1}' |
            sort -u
    )

    # 使用 command 因为自己覆盖了 apk 添加了 >&2
    retry 5 command apk search --quiet --exact ${firmware_pkgs:-linux-firmware-none}
}

get_ucode_firmware_pkgs() {
    is_virt && return

    case "$distro" in
    centos | almalinux | rocky | oracle | redhat | anolis | opencloudos | openeuler) os=elol ;;
    *) os=$distro ;;
    esac

    case "$os-$(get_cpu_vendor)" in
    # alpine 的 linux-firmware 以文件夹进行拆分
    # setup-alpine 会自动安装需要的 firmware（modloop 没挂载则无效）
    # https://github.com/alpinelinux/alpine-conf/blob/3.18.1/setup-disk.in#L421
    alpine-intel) echo intel-ucode ;;
    alpine-amd) echo amd-ucode ;;
    alpine-*) ;;

    debian-intel) echo firmware-linux intel-microcode ;;
    debian-amd) echo firmware-linux amd64-microcode ;;
    debian-*) echo firmware-linux ;;

    ubuntu-intel) echo linux-firmware intel-microcode ;;
    ubuntu-amd) echo linux-firmware amd64-microcode ;;
    ubuntu-*) echo linux-firmware ;;

    # 无法同时安装 kernel-firmware kernel-firmware-intel
    opensuse-intel) echo kernel-firmware ucode-intel ;;
    opensuse-amd) echo kernel-firmware ucode-amd ;;
    opensuse-*) echo kernel-firmware ;;

    arch-intel) echo linux-firmware intel-ucode ;;
    arch-amd) echo linux-firmware amd-ucode ;;
    arch-*) echo linux-firmware ;;

    gentoo-intel) echo linux-firmware intel-microcode ;;
    gentoo-amd) echo linux-firmware ;;
    gentoo-*) echo linux-firmware ;;

    nixos-intel) echo linux-firmware microcodeIntel ;;
    nixos-amd) echo linux-firmware microcodeAmd ;;
    nixos-*) echo linux-firmware ;;

    fedora-intel) echo linux-firmware microcode_ctl ;;
    fedora-amd) echo linux-firmware amd-ucode-firmware microcode_ctl ;;
    fedora-*) echo linux-firmware microcode_ctl ;;

    elol-intel) echo linux-firmware microcode_ctl ;;
    elol-amd) echo linux-firmware microcode_ctl ;;
    elol-*) echo linux-firmware microcode_ctl ;;
    esac
}

chroot_systemctl_disable() {
    local os_dir=$1
    shift

    for unit in "$@"; do
        # 如果传进来的是x(没有.) 则改成 x.service
        if ! [[ "$unit" = "*.*" ]]; then
            unit=$i.service
        fi

        # debian 10 返回值始终是 0
        if ! chroot $os_dir systemctl list-unit-files "$unit" 2>&1 | grep -Eq '^0 unit'; then
            chroot $os_dir systemctl disable "$unit"
        fi
    done
}

remove_or_disable_cloud_init() {
    local os_dir=$1

    if ! is_have_cmd_on_disk $os_dir cloud-init; then
        return
    fi

    info "Remove or Disable Cloud-Init"

    # ubuntu-server-minimal ubuntu-cloud-minimal 都包含 cloud-init
    # 用 iso 安装的 ubuntu 也有 cloud-init
    # 因此不删除 ubuntu 的 cloud-init，而是禁用它

    # iso 安装首次启动是通过 /etc/cloud/cloud.cfg.d/99-installer.cfg 初始化系统，包括：
    #     1. 创建普通用户和密码，添加 ssh 登录公钥
    #     2. 创建 /etc/cloud/cloud-init.disabled

    if grep -iq ubuntu $os_dir/etc/os-release; then
        # 模仿 iso 安装的 ubuntu，只创建 cloud-init.disabled，不禁用服务
        touch $os_dir/etc/cloud/cloud-init.disabled
    else
        # systemctl is-enabled cloud-init-hotplugd.service 状态是 static
        # disable 会出现一堆提示信息，也无法 disable
        for unit in $(
            chroot $os_dir systemctl list-unit-files |
                grep -E '^(cloud-init|cloud-init-.*|cloud-config|cloud-final)\.(service|socket)' | grep enabled | awk '{print $1}'
        ); do
            # 服务不存在时会报错
            if chroot $os_dir systemctl -q is-enabled "$unit"; then
                chroot $os_dir systemctl disable "$unit"
            fi
        done

        for pkg_mgr in dnf yum zypper apt-get; do
            if is_have_cmd_on_disk $os_dir $pkg_mgr; then
                case $pkg_mgr in
                dnf | yum)
                    chroot $os_dir $pkg_mgr remove -y cloud-init
                    rm -f $os_dir/etc/cloud/cloud.cfg.rpmsave
                    ;;
                zypper)
                    # 防止删除 cloud-init 时自动删除 sudo
                    if ! [ "$username" = root ]; then
                        sed -i '/^sudo$/d' "$os_dir/var/lib/zypp/AutoInstalled"
                    fi
                    # 加上 -u 才会删除依赖
                    chroot $os_dir zypper remove -y -u cloud-init cloud-init-config-suse
                    ;;
                apt-get)
                    # ubuntu 25.04 开始有 cloud-init-base
                    chroot_apt_remove $os_dir cloud-init cloud-init-base
                    chroot_apt_autoremove $os_dir
                    ;;
                esac
                break
            fi
        done
    fi
}

disable_jeos_firstboot() {
    local os_dir=$1
    info "Disable JeOS Firstboot"

    # 两种方法都可以
    # https://github.com/openSUSE/jeos-firstboot?tab=readme-ov-file#usage

    rm -rf $os_dir/var/lib/YaST2/reconfig_system

    for name in jeos-firstboot jeos-firstboot-snapshot; do
        # 服务不存在时会报错
        chroot $os_dir systemctl disable "$name.service" 2>/dev/null || true
    done

    # 可选
    # chroot $os_dir zypper remove -y -u jeos-firstboot
}

create_network_manager_config() {
    local source_cfg=$1
    local os_dir=$2
    info "Create Network-Manager config"

    # 可以直接用 alpine 的 cloud-init 生成 Network Manager 配置
    apk add cloud-init
    cloud-init devel net-convert -p "$source_cfg" -k yaml -d /out -D alpine -O network-manager

    # 文档明确写了 ipv6.method=dhcp 无法获取网关
    # https://networkmanager.dev/docs/api/latest/nm-settings-nmcli.html#:~:text=false/no/off-,ipv6,-.method
    sed -i -e '/^may-fail=/d' -e 's/^method=dhcp/method=auto/' \
        /out/etc/NetworkManager/system-connections/cloud-init-eth*.nmconnection

    # 删除 # Generated by cloud-init. Changes will be lost.
    # 删除 org.freedesktop.NetworkManager.origin=cloud-init
    # 并删除头部的空行
    sed -i \
        -e '/^# Generated by cloud-init/d' \
        -e '/^org\.freedesktop\.NetworkManager\.origin=cloud-init/d' \
        /out/etc/NetworkManager/system-connections/cloud-init-eth*.nmconnection
    del_head_empty_lines_inplace /out/etc/NetworkManager/system-connections/cloud-init-eth*.nmconnection

    cp /out/etc/NetworkManager/system-connections/cloud-init-eth*.nmconnection \
        $os_dir/etc/NetworkManager/system-connections/

    # 清理
    rm -rf /out
    apk del cloud-init

    # 最终显示文件
    for file in "$os_dir"/etc/NetworkManager/system-connections/cloud-init-eth*.nmconnection; do
        cat -n "$file" >&2
    done
}

modify_linux() {
    local os_dir=$1
    info "Modify Linux"

    find_and_mount() {
        mount_point=$1
        mount_dev=$(awk "\$2==\"$mount_point\" {print \$1}" $os_dir/etc/fstab)
        mount_opts=$(awk "\$2==\"$mount_point\" {print \$4}" $os_dir/etc/fstab)
        if [ -n "$mount_dev" ]; then
            mount -o "$mount_opts" "$mount_dev" "$os_dir$mount_point"
        fi
    }

    # 修复 onlink 网关
    add_onlink_script_if_need() {
        for ethx in $(get_eths); do
            if is_staticv4 || is_staticv6; then
                fix_sh=cloud-init-fix-onlink.sh
                download "$confhome/deprecated/$fix_sh" "$os_dir/$fix_sh"
                insert_into_file "$ci_file" after '^runcmd:' <<EOF
  - bash "/$fix_sh" && rm -f "/$fix_sh"
EOF
                break
            fi
        done
    }

    # 部分镜像有默认配置，例如 centos
    del_exist_sysconfig_NetworkManager_config $os_dir

    # 仅 fedora (el/ol/国产fork 用的是复制文件方法)
    # 1. 禁用 selinux kdump
    # 2. 添加微码+固件
    if [ -f $os_dir/etc/redhat-release ]; then
        # 防止删除 cloud-init / 安装 firmware 时不够内存
        create_swap_if_ram_less_than 2048 $os_dir/swapfile

        mount_pseudo_fs $os_dir

        # find_and_mount /boot
        # find_and_mount /boot/efi
        # fedora 的 fstab 还有 /home /var，因此用 mount -a
        # 不然无法往 /home/$username 写入 ssh 公钥
        chroot $os_dir mount -a

        cp_resolv_conf $os_dir

        # 可以直接用 alpine 的 cloud-init 生成 Network Manager 配置
        create_cloud_init_network_config /net.cfg
        create_network_manager_config /net.cfg "$os_dir"
        rm /net.cfg

        # TODO: fedora 43 eol 后删除
        # 删除 cloud-init 会删除依赖包 netcat
        # 但是删除 netcat 时会报错
        # 因此保留 netcat 包
        # >>> Running %preun scriptlet: netcat-0:1.229-3.fc43.x86_64
        # >>> Error in %preun scriptlet: netcat-0:1.229-3.fc43.x86_64
        # >>> Scriptlet output:
        # >>> failed to create admindir: No such file or directory
        # >>> [RPM] %preun(netcat-1.229-3.fc43.x86_64) scriptlet failed, exit status 2
        # >>> [RPM] netcat-1.229-3.fc43.x86_64: erase failed
        if [ "$distro" = fedora ] && [ "$releasever" = 43 ]; then
            chroot $os_dir dnf mark user netcat -y
        fi
        remove_or_disable_cloud_init $os_dir

        disable_selinux $os_dir
        disable_kdump $os_dir

        if fw_pkgs=$(get_ucode_firmware_pkgs) && [ -n "$fw_pkgs" ]; then
            is_have_cmd_on_disk $os_dir dnf && mgr=dnf || mgr=yum
            chroot $os_dir $mgr install -y $fw_pkgs
        fi

        restore_resolv_conf $os_dir
    fi

    # debian
    # 1. EOL 换源
    # 2. 修复网络问题
    # 3. 添加微码+固件
    # 注意 ubuntu 也有 /etc/debian_version
    if [ "$distro" = debian ]; then
        # 修复 onlink 网关
        # add_onlink_script_if_need

        mount_pseudo_fs $os_dir
        cp_resolv_conf $os_dir
        find_and_mount /boot
        find_and_mount /boot/efi

        remove_or_disable_cloud_init $os_dir

        # 获取当前开启的 Components, 后面要用
        if [ -f $os_dir/etc/apt/sources.list.d/debian.sources ]; then
            comps=$(grep ^Components: $os_dir/etc/apt/sources.list.d/debian.sources | head -1 | cut -d' ' -f2-)
        else
            comps=$(grep '^deb ' $os_dir/etc/apt/sources.list | head -1 | cut -d' ' -f4-)
        fi

        # ELTS/CN 源处理
        if is_elts; then
            # ELTS
            wget https://deb.freexian.com/extended-lts/archive-key.gpg \
                -O $os_dir/etc/apt/trusted.gpg.d/freexian-archive-extended-lts.gpg

            # shellcheck disable=SC1091
            codename=$({ . "$os_dir/etc/os-release" && echo "$VERSION_CODENAME"; })
            if [ -f $os_dir/etc/apt/sources.list.d/debian.sources ]; then
                cat <<EOF >$os_dir/etc/apt/sources.list.d/debian.sources
Types: deb
URIs: http://$deb_mirror
Suites: $codename
Components: $comps
Signed-By: /etc/apt/trusted.gpg.d/freexian-archive-extended-lts.gpg
EOF
            else
                echo "deb http://$deb_mirror $codename $comps" >$os_dir/etc/apt/sources.list
            fi
        else
            # non-ELTS
            if is_in_china; then
                # 不处理 security 源 security.debian.org/debian-security 和 /etc/apt/mirrors/debian-security.list
                for file in $os_dir/etc/apt/mirrors/debian.list $os_dir/etc/apt/sources.list; do
                    if [ -f "$file" ]; then
                        sed -i "s|deb\.debian\.org/debian|$deb_mirror|" "$file"
                    fi
                done
            fi
        fi

        # 标记所有内核为自动安装
        pkgs=$(chroot $os_dir apt-mark showmanual linux-image* linux-headers*)
        chroot $os_dir apt-mark auto $pkgs

        # 安装合适的内核
        kernel_package=$kernel
        # shellcheck disable=SC2046
        # 检测机器是否能用 cloud 内核
        if [[ "$kernel_package" = 'linux-image-cloud-*' ]] &&
            ! sh /can_use_cloud_kernel.sh "$xda" $(get_eths); then
            kernel_package=$(echo "$kernel_package" | sed 's/-cloud//')
        fi

        # 该方法包含了 apt-mark manual
        chroot_apt_install $os_dir "$kernel_package"

        # 使用 autoremove 删除非最佳内核
        chroot_apt_autoremove $os_dir

        # 微码+固件
        if fw_pkgs=$(get_ucode_firmware_pkgs) && [ -n "$fw_pkgs" ]; then
            #  debian 10 11 的 iucode-tool 在 contrib 里面
            #  debian 12 的 iucode-tool 在 main 里面
            [ "$releasever" -ge 12 ] &&
                comps_to_add=non-free-firmware ||
                comps_to_add="contrib non-free"

            if [ -f $os_dir/etc/apt/sources.list.d/debian.sources ]; then
                file=$os_dir/etc/apt/sources.list.d/debian.sources
                search='^[# ]*Components:'
            else
                file=$os_dir/etc/apt/sources.list
                search='^[# ]*deb'
            fi

            for c in $comps_to_add; do
                if ! echo "$comps" | grep -wq "$c"; then
                    sed -Ei "/$search/s/$/ $c/" $file
                fi
            done

            chroot_apt_install $os_dir $fw_pkgs
        fi

        # genericcloud 删除以下文件开机时才会显示 grub 菜单
        # https://salsa.debian.org/cloud-team/debian-cloud-images/-/tree/master/config_space/bookworm/files/etc/default/grub.d
        rm -f $os_dir/etc/default/grub.d/10_cloud.cfg
        rm -f $os_dir/etc/default/grub.d/15_timeout.cfg
        chroot $os_dir update-grub

        if true; then
            # 如果使用 nocloud 镜像
            chroot_apt_install $os_dir openssh-server
        else
            # 如果使用 genericcloud 镜像

            # 还原默认配置并创建 key
            # cat $os_dir/usr/share/openssh/sshd_config $os_dir/etc/ssh/sshd_config
            # chroot $os_dir ssh-keygen -A
            rm -rf $os_dir/etc/ssh/sshd_config
            UCF_FORCE_CONFFMISS=1 chroot $os_dir dpkg-reconfigure openssh-server
        fi

        # 镜像自带的网络管理器
        # debian 11 ifupdown
        # debian 12 netplan + networkd + resolved
        # ifupdown dhcp 不支持 24位掩码+不规则网关?

        # 强制使用 netplan
        if false && is_have_cmd_on_disk $os_dir netplan; then
            chroot_apt_install $os_dir netplan.io
            # 服务不存在时会报错
            chroot $os_dir systemctl disable networking resolvconf 2>/dev/null || true
            chroot $os_dir systemctl enable systemd-networkd systemd-resolved
            rm_resolv_conf $os_dir
            ln -sf ../run/systemd/resolve/stub-resolv.conf $os_dir/etc/resolv.conf
            if [ -f "$os_dir/etc/cloud/cloud.cfg.d/99_fallback.cfg" ]; then
                insert_into_file $os_dir/etc/cloud/cloud.cfg.d/99_fallback.cfg after '#cloud-config' <<EOF
system_info:
  network:
    renderers: [netplan]
    activators: [netplan]
EOF
            fi
        fi

        create_ifupdown_config $os_dir/etc/network/interfaces

        # ifupdown 不支持 rdnss
        # 但 iso 安装不会安装 rdnssd，而是在安装时读取 rdnss 并写入 resolv.conf
        if false; then
            chroot_apt_install $os_dir rdnssd
        fi

        # debian 10 11 云镜像安装了 resolvconf
        # debian 12 云镜像安装了 netplan systemd-resolved
        # 云镜像用了 cloud-init 自动配置网络，用户是无感的，因此官方云镜像可以随便选择网络管理器
        # 但我们的系统安装后用户可能有手动配置网络的需求，因此用回 iso 安装时的网络管理器 ifupdown

        # 服务不存在时会报错
        chroot $os_dir systemctl disable resolvconf systemd-networkd systemd-resolved 2>/dev/null || true

        chroot_apt_install $os_dir ifupdown
        chroot_apt_remove $os_dir resolvconf netplan.io systemd-resolved
        chroot_apt_autoremove $os_dir
        chroot $os_dir systemctl enable networking

        # 静态时 networking 服务不会根据 /etc/network/interfaces 更新 resolv.conf
        # 动态时使用了 isc-dhcp-client 支持自动更新 resolv.conf
        # 另外 debian iso 不会安装 rdnssd
        keep_now_resolv_conf $os_dir
    fi

    # opensuse
    # 1. kernel-default-base 缺少 nvme gve mlx5 mana 驱动，换成 kernel-default
    # 2. 添加微码+固件
    # https://documentation.suse.com/smart/virtualization-cloud/html/minimal-vm/index.html
    if grep -q opensuse $os_dir/etc/os-release; then
        create_swap_if_ram_less_than 1024 $os_dir/swapfile
        mount_pseudo_fs $os_dir
        cp_resolv_conf $os_dir
        find_and_mount /boot
        find_and_mount /boot/efi

        disable_jeos_firstboot $os_dir

        # 禁用 selinux
        disable_selinux $os_dir

        # opensuse leap 16.0 / tumbleweed 用 NetworkManager
        # 可以直接用 alpine 的 cloud-init 生成 Network Manager 配置
        create_cloud_init_network_config /net.cfg
        create_network_manager_config /net.cfg "$os_dir"
        rm /net.cfg

        # 选择新内核
        # 只有 leap 有 kernel-azure
        if grep -iq leap $os_dir/etc/os-release && [ "$(get_cloud_vendor)" = azure ]; then
            target_kernel='kernel-azure'
        else
            target_kernel='kernel-default'
        fi

        # rpm -qi 不支持通配符
        origin_kernel=$(chroot $os_dir rpm -qa 'kernel-*' --qf '%{NAME}\n' | grep -v firmware)
        if ! [ "$(echo "$origin_kernel" | wc -l)" -eq 1 ]; then
            error_and_exit "Unexpected kernel installed: $origin_kernel"
        fi

        # 16.0 能同时装 kernel-default-base 和 kernel-default
        # tw 不能同时装 kernel-default-base 和 kernel-default
        # 因此需要添加 --force-resolution 自动删除 kernel-default-base
        if ! [ "$origin_kernel" = "$target_kernel" ]; then
            # x86 必须设置一个密码，否则报错，arm 没有这个问题
            # Failed to get root password hash
            # Failed to import /etc/uefi/certs/76B6A6A0.crt
            # warning: %post(kernel-default-5.14.21-150500.55.83.1.x86_64) scriptlet failed, exit status 255
            need_password_workaround=false
            if grep -q '^root:[:!*]' $os_dir/etc/shadow; then
                need_password_workaround=true
            fi

            if $need_password_workaround; then
                echo "root:$(mkpasswd '')" | chroot $os_dir chpasswd -e
            fi
            # 安装新内核
            chroot $os_dir zypper install -y --force-resolution $target_kernel
            # 删除旧内核
            if chroot $os_dir rpm -q $origin_kernel; then
                chroot $os_dir zypper remove -y --force-resolution $origin_kernel
            fi
            if $need_password_workaround; then
                chroot $os_dir passwd -d -l root
            fi
        fi

        # 固件+微码
        if fw_pkgs=$(get_ucode_firmware_pkgs) && [ -n "$fw_pkgs" ]; then
            chroot $os_dir zypper install -y $fw_pkgs
        fi

        # 最后才删除 cloud-init
        # 因为生成 sysconfig 网络配置要用目标系统的 cloud-init
        remove_or_disable_cloud_init $os_dir

        restore_resolv_conf $os_dir
    fi

    # arch 云镜像
    if false && [ -f $os_dir/etc/arch-release ]; then
        # 修复 onlink 网关
        add_onlink_script_if_need

        # 同步证书
        cp_resolv_conf $os_dir
        mount_pseudo_fs $os_dir
        chroot $os_dir pacman-key --init
        chroot $os_dir pacman-key --populate
        rm_resolv_conf $os_dir
    fi

    # gentoo 云镜像
    if false && [ -f $os_dir/etc/gentoo-release ]; then
        # 挂载伪文件系统
        mount_pseudo_fs $os_dir
        cp_resolv_conf $os_dir

        # 在这里修改密码，而不是用cloud-init，因为我们的默认密码太弱
        is_password_plaintext && sed -i 's/enforce=everyone/enforce=none/' $os_dir/etc/security/passwdqc.conf
        change_user_password $os_dir
        is_password_plaintext && sed -i 's/enforce=none/enforce=everyone/' $os_dir/etc/security/passwdqc.conf

        # 下载仓库，选择 profile
        # https://github.com/gentoo/gentoo/blob/master/profiles/profiles.desc
        chroot $os_dir emerge-webrsync
        profile=$(chroot $os_dir eselect profile list | grep stable | grep systemd |
            awk '{print length($2), $2}' | sort -n | head -1 | awk '{print $2}')
        chroot $os_dir eselect profile set $profile

        # 删除 resolv.conf，不然 systemd-resolved 无法创建软链接
        rm_resolv_conf $os_dir

        # 启用网络服务
        chroot $os_dir systemctl enable systemd-networkd
        chroot $os_dir systemctl enable systemd-resolved

        # systemd-networkd 有时不会运行
        # https://bugs.gentoo.org/910404 补丁好像没用
        # https://github.com/systemd/systemd/issues/27718#issuecomment-1564877478
        # 临时的解决办法是运行 networkctl，如果启用了systemd-networkd服务，会运行服务
        insert_into_file $os_dir/lib/systemd/system/systemd-logind.service after '\[Service\]' <<EOF
ExecStartPost=-networkctl
EOF

        # 如果创建了 cloud-init.disabled，重启后网络不受 networkd 管理
        # 因为网卡名变回了 ens3 而不是 eth0
        # 因此要删除 networkd 的网卡名匹配
        insert_into_file $ci_file after '^runcmd:' <<EOF
  - sed -i '/^Name=/d' /etc/systemd/network/10-cloud-init-eth*.network
EOF

        # 修复 onlink 网关
        add_onlink_script_if_need
    fi

    basic_init $os_dir

    # 应该在这里是否运行了 basic_init 和创建了网络配置文件
    # 如果没有，则使用 cloud-init

    # 查看 cloud-init 最终配置
    if [ -f "$ci_file" ]; then
        cat -n "$ci_file"
    fi

    # 删除 swap
    swapoff -a
    rm -f $os_dir/swapfile
}

setup_nocloud() {
    local os_dir=$1
    info "Setup NoCloud"

    # 1. 配置 NoCloud-only datasource
    mkdir -p "$os_dir/etc/cloud/cloud.cfg.d"
    cat >"$os_dir/etc/cloud/cloud.cfg.d/99-datasource.cfg" <<'EOF'
datasource_list: [ NoCloud, None ]
datasource:
  NoCloud:
    seedfrom: /var/lib/cloud/seed/nocloud/
    fs_label: null
EOF

    # 2. 复制 seed 文件（已在 host 上准备好，打包在 initrd 中）
    mkdir -p "$os_dir/var/lib/cloud/seed/nocloud"
    cp /configs/cloud-data/* "$os_dir/var/lib/cloud/seed/nocloud/"

    # 3. 确保 cloud-init 没有被禁用
    rm -f "$os_dir/etc/cloud/cloud-init.disabled"

    # 4. 清除 cloud-init 旧状态，确保首次启动重新执行
    rm -rf "$os_dir/var/lib/cloud/instance"
    rm -rf "$os_dir/var/lib/cloud/instances"
}

modify_os_on_disk() {
    only_process=$1
    info "Modify disk if is $only_process"

    update_part

    # dd linux 的时候不用修改硬盘内容（nocloud 模式除外）
    if [ "$distro" = "dd" ] && [ "$only_process" != "nocloud" ] && ! lsblk -f /dev/$xda | grep ntfs; then
        return
    fi

    mkdir -p /os
    # 按分区容量大到小，依次寻找系统分区
    # lsblk /dev/mmcblk0* 会列出 mmcblk0boot0 mmcblk0boot1
    # lsblk /dev/mmcblk0  不会列出 mmcblk0boot0 mmcblk0boot1
    for part in $(lsblk /dev/$xda --filter 'TYPE == "part"' --sort SIZE -no NAME | tac); do
        # btrfs挂载的是默认子卷，如果没有默认子卷，挂载的是根目录
        # fedora 云镜像没有默认子卷，且系统在root子卷中
        if mount -o ro /dev/$part /os; then
            if [ "$only_process" = linux ] || [ "$only_process" = nocloud ]; then
                if etc_dir=$({ ls -d /os/etc/ || ls -d /os/*/etc/; } 2>/dev/null); then
                    local os_dir
                    os_dir=$(dirname $etc_dir)
                    # 重新挂载为读写
                    mount -o remount,rw /os
                    if [ "$only_process" = nocloud ]; then
                        setup_nocloud $os_dir
                    else
                        modify_linux $os_dir
                    fi
                    return
                fi
            elif [ "$only_process" = windows ]; then
                # find 不是很聪明
                # find /mnt/c -iname windows -type d -maxdepth 1
                # find: /mnt/c/pagefile.sys: Permission denied
                # find: /mnt/c/swapfile.sys: Permission denied
                # shellcheck disable=SC1090
                # find_file_ignore_case 也在这个文件里面
                . <(wget -O- $confhome/windows-driver-utils.sh)
                if find_file_ignore_case /os/Windows/System32/ntoskrnl.exe >/dev/null 2>&1; then
                    # 其他地方会用到
                    is_windows() { true; }
                    # 重新挂载为读写、忽略大小写
                    umount /os
                    if ! { mount -t ntfs3 -o nocase,rw /dev/$part /os &&
                        mount | grep -w 'on /os type' | grep -wq rw; }; then
                        # 显示警告
                        warn "Can't normally mount windows partition /dev/$part as rw."
                        dmesg | grep -F "ntfs3($part):" || true
                        # 有可能 fallback 挂载成 ro, 因此先取消挂载
                        if mount | grep -wq 'on /os type'; then
                            umount /os
                        fi
                        # 尝试修复并强制挂载
                        apk add ntfs-3g-progs
                        ntfsfix /dev/$part
                        apk del ntfs-3g-progs
                        mount -t ntfs3 -o nocase,rw,force /dev/$part /os
                    fi
                    # 获取版本号，其他地方会用到
                    get_windows_version_from_windows_drive /os
                    modify_windows /os
                    return
                fi
            fi
            umount /os
        fi
    done
    error_and_exit "Can't find os partition."
}

get_need_swap_size() {
    need_ram=$1
    phy_ram=$(get_approximate_ram_size)

    if [ $need_ram -gt $phy_ram ]; then
        echo $((need_ram - phy_ram))
    else
        echo 0
    fi
}

create_swap_if_ram_less_than() {
    need_ram=$1
    swapfile=$2

    swapsize=$(get_need_swap_size $need_ram)
    if [ $swapsize -gt 0 ]; then
        create_swap $swapsize $swapfile
    fi
}

create_swap() {
    swapsize=$1
    swapfile=$2

    if ! grep $swapfile /proc/swaps; then
        # 用兼容 btrfs 的方式创建 swapfile
        truncate -s 0 $swapfile
        # 如果分区不支持 chattr +C 会显示错误但返回值是 0
        chattr +C $swapfile 2>/dev/null
        fallocate -l ${swapsize}M $swapfile
        chmod 0600 $swapfile
        mkswap $swapfile
        swapon $swapfile
    fi
}

del_user_password_and_lock() {
    local os_dir=$1
    local username=$2

    # 锁定用户后 ssh 能否登录
    # alpine ×
    # 其它系统 √

    # root 空密码，不锁定 root，其它用户用 su - root 能否切换到 root
    # alpine ×
    # 其它系统 √

    # centos 7 不支持一行命令同时 -d -l
    # passwd: Only one of -l, -u, -d, -S may be specified.

    # 删除密码
    chroot "$os_dir" passwd -d "$username"

    # 锁定用户
    if ! [ -e "$os_dir/etc/alpine-release" ]; then
        chroot "$os_dir" passwd -l "$username"
    fi

    # alpine 锁定用户无法登录 ssh
    # 因为 alpine 默认不开启 pam
    # 其他系统默认开启

    # 不开启 pam 的话，锁定用户无法登录 ssh
    # 开启 pam 后可以

    # alpine 是通过安装 openssh-server-pam 开启 pam
    # 不需要设置 UsePAM yes 也无法识别 UsePAM yes
    # localhost:~# sshd -G | grep -i pam
    # /etc/ssh/sshd_config line 88: Unsupported option UsePAM
}

set_ssh_keys_and_del_password() {
    local os_dir=$1

    info 'set ssh keys'

    if [ "$username" = root ]; then
        local user_home="/root"
    else
        local user_home="/home/$username"
    fi

    # 添加公钥
    if true; then
        (
            umask 077
            mkdir -p "$os_dir/$user_home/.ssh"
            cat /configs/ssh_keys >"$os_dir/$user_home/.ssh/authorized_keys"
        )
        # 注意要用 chroot，否则 uid/gid 是 alpine live os 下的 uid/gid
        chroot "$os_dir" chown "$username:$username" "$user_home"
        chroot "$os_dir" chown "$username:$username" "$user_home/.ssh"
        chroot "$os_dir" chown "$username:$username" "$user_home/.ssh/authorized_keys"
    else
        (
            # 如果日后添加 bsd 无法 chroot 时可以这样
            umask 077
            read -r owner group < \
                <(awk -F: -v user="$username" '$1==user {print $3,$4}' "$os_dir/etc/passwd")
            install -D \
                -m 600 \
                -o "$owner" \
                -g "$group" \
                /configs/ssh_keys \
                "$os_dir/$user_home/.ssh/authorized_keys"
        )
    fi

    # 删除密码/锁定用户
    del_user_password_and_lock "$os_dir" "$username"

    # debian 云镜像 /etc/shadow 的 root 条目为
    # root:!unprovisioned:20591:0:99999:7:::
    # 首次开机会停在设置 root 密码界面，且阻塞 ssh 服务
    # 因此这里手动清空 root 密码并锁定
    if ! [ "$username" = root ] && is_have_cmd_on_disk "$os_dir" systemd-firstboot; then
        del_user_password_and_lock "$os_dir" root
    fi
}

is_ssh_kv_effective() {
    local os_dir=$1
    local key=$2
    local value=$3

    # 解决 ubuntu 22.04 报错
    # Missing privilege separation directory: /run/sshd
    if [ -d "$os_dir/run/sshd" ]; then
        we_create_run_sshd_dir=false
    else
        we_create_run_sshd_dir=true
        mkdir -p "$os_dir/run/sshd"
    fi

    # centos 7 / ubuntu 22.04 不支持 -G
    # -G 只检测配置文件
    # -T 会检测配置文件、host key
    if res=$(chroot "$os_dir" sshd -G 2>/dev/null || chroot "$os_dir" sshd -T 2>/dev/null); then
        # 删除自己创建的，避免后续权限不准确
        if $we_create_run_sshd_dir; then
            rm -rf "$os_dir/run/sshd"
        fi

        # centos 7 设置 prohibit-password ，sshd -T 会显示成 without-password
        printf "%s\n" "$res" |
            sed 's/^permitrootlogin without-password$/permitrootlogin prohibit-password/i' |
            if [ -n "$value" ]; then
                grep -F -xiq "$key $value"
            else
                # value 为空时，只验证 key 是否存在
                grep -E -xiq "$key .*"
            fi
    else
        error_and_exit "Failed to verify sshd config."
    fi
}

change_ssh_conf_if_different() {
    local os_dir=$1
    local key=$2
    local value=$3
    local explicit=${4:-false} # 是否需要显式设置

    # 有些发行版自带了某些配置，例如
    # ubuntu:
    # cat /etc/ssh/sshd_config.d/60-cloudimg-settings.conf | grep -i PasswordAuthentication
    # PasswordAuthentication no

    # gentoo:
    # cat /etc/ssh/sshd_config.d/9999999gentoo-pam.conf | grep -i PasswordAuthentication
    # PasswordAuthentication no

    # 0. 如果已经有这个配置，且不需要显式设置，则不修改
    if is_ssh_kv_effective "$os_dir" "$key" "$value" && ! $explicit; then
        return
    fi

    if line="^$key .*" && grep -Exiq "$line" $os_dir/etc/ssh/sshd_config 2>/dev/null; then
        # 1. 如果 sshd_config 存在此 key（非注释状态），则替换
        sed -Ei "s/$line/$key $value/" $os_dir/etc/ssh/sshd_config
    elif include_line='^Include .*/etc/ssh/sshd_config.d' &&
        # 2. 如果 sshd_config 设置了读取 sshd_config.d
        #    则写入到 sshd_config.d/01-xxx.conf

        # arch 没有 /etc/ssh/sshd_config.d/ 文件夹
        # opensuse tumbleweed 没有 /etc/ssh/sshd_config
        #                       有 /etc/ssh/sshd_config.d/ 文件夹
        #                       有 /usr/etc/ssh/sshd_config
        { grep -iq "$include_line" $os_dir/etc/ssh/sshd_config ||
            grep -iq "$include_line" $os_dir/usr/etc/ssh/sshd_config; } 2>/dev/null; then
        mkdir -p $os_dir/etc/ssh/sshd_config.d/
        echo "$key $value" >"$os_dir/etc/ssh/sshd_config.d/01-$(echo "$key" | to_lower).conf"
    else
        # 3. 写入 sshd_config
        #    如果 sshd_config 存在此 key (无论是否已注释)，则替换，包括删除注释
        #    否则追加
        line="^[# ]*$key .*"
        if grep -Exiq "$line" $os_dir/etc/ssh/sshd_config; then
            sed -Ei "s/$line/$key $value/" $os_dir/etc/ssh/sshd_config
        else
            echo "$key $value" >>$os_dir/etc/ssh/sshd_config
        fi
    fi

    # 验证是否成功
    if ! is_ssh_kv_effective "$os_dir" "$key" "$value"; then
        error_and_exit "Failed to set sshd config $key $value."
    fi
}

change_ssh_conf_for_key_login() {
    local os_dir=$1

    change_ssh_conf_if_different "$os_dir" PasswordAuthentication no

    # centos 7 PermitRootLogin 默认是 yes，而不是 prohibit-password
    if [ "$username" = root ]; then
        change_ssh_conf_if_different "$os_dir" PermitRootLogin prohibit-password
    fi

    # sshd -G/-T 有 ChallengeResponseAuthentication 说明是旧版 sshd
    # 才需要设置 ChallengeResponseAuthentication no

    # OpenSSH 8.6 和以下 (包括 el8/debian 11/ubuntu 20.04 等)
    # KbdInteractiveAuthentication ChallengeResponseAuthentication 可设置成不同的值
    # 如果没有显式设置 ChallengeResponseAuthentication no
    # 则 KbdInteractiveAuthentication no 不会生效 (sshd -G/-T 显示 KbdInteractiveAuthentication yes)

    # 因此先 sshd -G/-T 检测有没有 ChallengeResponseAuthentication 这个 key
    # 只要有就显式设置为 no
    # 而且要先设置 ChallengeResponseAuthentication 后设置 KbdInteractiveAuthentication
    # 否则 change_ssh_conf_if_different 设置 KbdInteractiveAuthentication no 时会检测到不生效而报错

    # 用户传进来的 rhel-like 系统可能是支持 ChallengeResponseAuthentication 的旧版本
    # 因此即使 el8/debian 11/ubuntu 20.04 都 EOL 后也不能删除这里
    if is_ssh_kv_effective "$os_dir" ChallengeResponseAuthentication; then
        change_ssh_conf_if_different "$os_dir" ChallengeResponseAuthentication no true
    fi

    # PasswordAuthentication no
    # KbdInteractiveAuthentication yes (默认是 yes)
    # 这种情况可以用密码登录
    # ssh -o PreferredAuthentications=keyboard-interactive user@ip

    # 多数发行版都会在 sshd_config 里设置成 no
    # 但 opensuse 16 没有
    change_ssh_conf_if_different "$os_dir" KbdInteractiveAuthentication no
}

change_ssh_conf_for_password_login() {
    local os_dir=$1

    # opensuse 16/tumbleweed 安装 openssh-server-config-rootlogin
    # 会生成 /usr/etc/ssh/sshd_config.d/50-permit-root-login.conf
    # 但是如果用户删除了此文件，包有更新的话，可能会重新创建这个文件？
    # 因此先不用这个方法
    if false &&
        [ -f $os_dir/etc/os-release ] &&
        grep -iq opensuse $os_dir/etc/os-release; then
        chroot $os_dir zypper install -y openssh-server-config-rootlogin
    fi

    # PasswordAuthentication 默认是 yes
    # 但某些发行版会在 sshd_config.d 里设置 PasswordAuthentication no
    change_ssh_conf_if_different "$os_dir" PasswordAuthentication yes

    if [ "$username" = root ]; then
        change_ssh_conf_if_different "$os_dir" PermitRootLogin yes
    fi
}

change_ssh_port() {
    local os_dir=$1
    local ssh_port=$2

    change_ssh_conf_if_different "$os_dir" Port "$ssh_port"
}

# 暂时用不着
add_user_if_need_for_alpine() {
    local os_dir=$1

    if ! grep -q "^$username:" "$os_dir/etc/passwd"; then
        #  -a  Create admin user. Add to wheel group and set up doas
        #  -u  Unlock the user automatically (eg. creating the user non-interactively
        #      with an ssh key for login)
        if is_need_set_ssh_keys; then
            chroot "$os_dir" setup-user -a -u -k "$(cat /configs/ssh_keys)" "$username"
        else
            chroot "$os_dir" setup-user -a -u "$username"
            change_user_password $os_dir
        fi
    fi
}

add_user_if_need() {
    local os_dir=$1

    # 添加用户
    if ! grep -q "^$username:" "$os_dir/etc/passwd"; then
        # debian 推荐使用 adduser 而不是 useradd
        # https://manpages.debian.org/trixie/passwd/useradd.8.en.html
        # useradd is a low level utility for adding users.
        # On Debian, administrators should usually use adduser(8) instead.

        # adduser 会从 /etc/adduser.conf 读取默认要添加的组
        # 然而通常这个值是空白

        # alpine
        if is_have_cmd_on_disk "$os_dir" adduser &&
            chroot "$os_dir" adduser --help 2>&1 | grep -Fq -- BusyBox; then
            chroot "$os_dir" adduser --disabled-password "$username"

        # debian/ubuntu
        elif is_have_cmd_on_disk "$os_dir" adduser &&
            chroot "$os_dir" adduser --help 2>&1 | grep -Fq -- '--disabled-password'; then
            chroot "$os_dir" adduser --disabled-password --comment '' "$username"

        # el
        elif is_have_cmd_on_disk "$os_dir" adduser &&
            chroot "$os_dir" adduser --help 2>&1 | grep -Fq -- '--password'; then
            chroot "$os_dir" adduser --password ! "$username"

        # arch/gentoo 默认没有 adduser
        else
            chroot "$os_dir" useradd -m "$username"
        fi
    fi

    # 添加到 wheel/sudo 组
    if ! [ "$username" = root ]; then
        if [ -e "$os_dir/etc/alpine-release" ]; then
            # alpine
            # https://github.com/alpinelinux/alpine-conf/blob/master/setup-user.in#L168

            # 安装 doas
            chroot "$os_dir" apk add doas doas-sudo-shim
            mkdir -p "$os_dir/etc/doas.d"

            # 添加用户到组
            chroot "$os_dir" addgroup "$username" wheel

            # doas: 添加 wheel 组
            local file="$os_dir/etc/doas.d/20-wheel.conf"
            local content="permit persist :wheel"
            if ! grep -q "^$content" "$file" 2>/dev/null; then
                echo "$content" >>"$file"
            fi

            # doas: 添加单个用户 nopass
            echo "permit nopass $username" >"$os_dir/etc/doas.d/99-$username.conf"
        else
            # 通常用 wheel 组
            # debian/ubuntu 没有 wheel 组，只有 sudo 组

            # aws lightsail 上测试默认用户加入了哪些组
            # debian       admin : admin adm dialout cdrom floppy sudo audio dip video plugdev
            # ubuntu       ubuntu : ubuntu adm cdrom sudo dip lxd
            # almalinux    ec2-user : ec2-user adm systemd-journal
            # opensuse     ec2-user : ec2-user

            # 添加用户到组
            for group in \
                wheel sudo \
                adm dialout cdrom floppy audio dip video plugdev lxd systemd-journal; do
                if grep -q "^$group:" "$os_dir/etc/group"; then
                    # chroot "$os_dir" addgroup "$username" "$group"
                    chroot "$os_dir" usermod -aG "$group" "$username"
                fi
            done

            # sudo: gentoo 安装 sudo 后也没有 /etc/sudoers.d
            if ! [ -d "$os_dir/etc/sudoers.d" ]; then
                install -d -m 0750 "$os_dir/etc/sudoers.d"
            fi

            # sudo: 添加单个用户 NOPASSWD
            # https://wiki.archlinux.org/title/Sudo#Sudoers_default_file_permissions
            local file="$os_dir/etc/sudoers.d/99-$username"
            printf '%s\n' "$username ALL=(ALL) NOPASSWD:ALL" >"$file"
            chmod 0440 "$file"
        fi
    fi
}

change_user_password() {
    local os_dir=$1

    info 'change user password'

    if is_password_plaintext; then
        pam_d=$os_dir/etc/pam.d

        [ -f $pam_d/chpasswd ] && has_pamd_chpasswd=true || has_pamd_chpasswd=false

        if $has_pamd_chpasswd; then
            cp $pam_d/chpasswd $pam_d/chpasswd.orig

            # cat /etc/pam.d/chpasswd
            # @include common-password

            # cat /etc/pam.d/chpasswd
            # #%PAM-1.0
            # auth       include      system-auth
            # account    include      system-auth
            # password   substack     system-auth
            # -password   optional    pam_gnome_keyring.so use_authtok
            # password   substack     postlogin

            # 通过 /etc/pam.d/chpasswd 找到 /etc/pam.d/system-auth 或者 /etc/pam.d/system-auth
            # 再找到有 password 和 pam_unix.so 的行，并删除 use_authtok，写入 /etc/pam.d/chpasswd
            files=$(grep -E '^(password|@include)' $pam_d/chpasswd | awk '{print $NF}' | sort -u)
            for file in $files; do
                if [ -f "$pam_d/$file" ] && line=$(grep ^password "$pam_d/$file" | grep -F pam_unix.so); then
                    echo "$line" | sed 's/use_authtok//' >$pam_d/chpasswd
                    break
                fi
            done
        fi

        # 分两行写，不然遇到错误不会终止
        plaintext=$(get_password_plaintext)
        printf '%s\n' "$username:$plaintext" | chroot $os_dir chpasswd

        if $has_pamd_chpasswd; then
            mv $pam_d/chpasswd.orig $pam_d/chpasswd
        fi
    else
        printf '%s\n' "$username:$(get_password_linux_sha512)" | chroot $os_dir chpasswd -e
    fi
}

disable_selinux() {
    local os_dir=$1

    # https://access.redhat.com/solutions/3176
    # centos7 也建议将 selinux 开关写在 cmdline
    # grep selinux=0 /usr/lib/dracut/modules.d/98selinux/selinux-loadpolicy.sh
    #     warn "To disable selinux, add selinux=0 to the kernel command line."
    if [ -f $os_dir/etc/selinux/config ]; then
        sed -i 's/^SELINUX=enforcing/SELINUX=disabled/g' $os_dir/etc/selinux/config
    fi

    # opensuse 没有安装 grubby
    if is_have_cmd_on_disk $os_dir grubby; then
        # grubby 只处理 GRUB_CMDLINE_LINUX，不会处理 GRUB_CMDLINE_LINUX_DEFAULT
        # rocky 的 GRUB_CMDLINE_LINUX_DEFAULT 有 crashkernel=auto
        chroot $os_dir grubby --update-kernel ALL --args selinux=0

        # el7 上面那条 grubby 命令不能设置 /etc/default/grub
        sed -i 's/selinux=1/selinux=0/' $os_dir/etc/default/grub
    else
        # 有可能没有 selinux 参数，但现在的镜像没有这个问题
        # sed -Ei 's/[[:space:]]?(security|selinux|enforcing)=[^ ]*//g' $os_dir/etc/default/grub
        sed -i 's/selinux=1/selinux=0/' $os_dir/etc/default/grub

        # 如果需要用 snapshot 可以用 transactional-update grub.cfg
        chroot $os_dir grub2-mkconfig -o /boot/grub2/grub.cfg
    fi
}

disable_kdump() {
    local os_dir=$1

    # grubby 只处理 GRUB_CMDLINE_LINUX，不会处理 GRUB_CMDLINE_LINUX_DEFAULT
    # rocky 的 GRUB_CMDLINE_LINUX_DEFAULT 有 crashkernel=auto

    # 新安装的内核依然有 crashkernel，好像是 bug
    # https://forums.rockylinux.org/t/how-do-i-remove-crashkernel-from-cmdline/13346
    # 验证过程
    # yum remove --oldinstallonly   # 删除旧内核
    # rm -rf /boot/loader/entries/* # 删除启动条目
    # yum reinstall kernel-core     # 重新安装新内核
    # cat /boot/loader/entries/*    # 依然有 crashkernel=1G-4G:192M,4G-64G:256M,64G-:512M

    chroot $os_dir grubby --update-kernel ALL --args crashkernel=no
    # el7 上面那条 grubby 命令不能设置 /etc/default/grub
    sed -i 's/crashkernel=[^ "]*/crashkernel=no/' $os_dir/etc/default/grub
    if chroot $os_dir systemctl -q is-enabled kdump; then
        chroot $os_dir systemctl disable kdump
    fi
}

download_qcow() {
    apk add qemu-img
    info "Download qcow2 image"

    mkdir -p /installer
    mount /dev/disk/by-label/installer /installer

    qcow_file=/installer/cloud_image.qcow2
    if [ -n "$img_type_warp" ]; then
        # 边下载边解压，单线程下载
        # 用官方 wget ，带进度条
        apk add wget
        wget $img -O- | pipe_extract >$qcow_file
    else
        # 多线程下载
        download "$img" "$qcow_file"
    fi
}

connect_qcow() {
    modprobe nbd nbds_max=1
    qemu-nbd -c /dev/nbd0 $qcow_file

    # 需要等待一下
    # https://github.com/canonical/cloud-utils/blob/main/bin/mount-image-callback
    while ! blkid /dev/nbd0; do
        echo "Waiting for qcow file to be mounted..."
        sleep 5
    done
}

disconnect_qcow() {
    if [ -f /sys/block/nbd0/pid ]; then
        qemu-nbd -d /dev/nbd0

        # 需要等待一下
        while fuser -sm $qcow_file; do
            echo "Waiting for qcow file to be unmounted..."
            sleep 5
        done
    fi
}

get_part_size_mb_for_file_size_b() {
    local file_b=$1
    local file_mb=$((file_b / 1024 / 1024))

    # ext4 默认参数下
    #  分区大小   可用大小   利用率
    #  100 MiB      86 MiB   86.0%
    #  200 MiB     177 MiB   88.5%
    #  500 MiB     454 MiB   90.8%
    #  512 MiB     476 MiB   92.9%
    # 1024 MiB     957 MiB   93.4%
    # 2000 MiB    1914 MiB   95.7%
    # 2048 MiB    1929 MiB   94.1% 这里反而下降了
    # 5120 MiB    4938 MiB   96.4%

    # 文件系统大约占用 5% 空间

    # 假设 1929M 的文件，计算得到需要创建 2031M 的分区
    # 但是实测 2048M 的分区才能存放 1929M 的文件
    # 因此预留不足 150M 时补够 150M
    local reserve_mb=$((file_mb * 100 / 95 - file_mb))
    if [ $reserve_mb -lt 150 ]; then
        reserve_mb=150
    fi

    part_mb=$((file_mb + reserve_mb))
    echo "File size:      $file_mb MiB" >&2
    echo "Part size need: $part_mb MiB" >&2
    echo $part_mb
}

get_cloud_image_part_size() {
    # 7
    # https://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-2211.qcow2c 400m

    # 8
    # https://repo.almalinux.org/almalinux/8/cloud/x86_64/images/AlmaLinux-8-GenericCloud-latest.x86_64.qcow2 600m
    # https://download.rockylinux.org/pub/rocky/8/images/x86_64/Rocky-8-GenericCloud-Base.latest.x86_64.qcow2 1.8g
    # https://yum.oracle.com/templates/OracleLinux/OL8/u9/x86_64/OL8U9_x86_64-kvm-b219.qcow2 1g
    # https://rhel-8.10-x86_64-kvm.qcow2 1g

    # 9
    # https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-GenericCloud-9-latest.x86_64.qcow2 1.2g
    # https://repo.almalinux.org/almalinux/9/cloud/x86_64/images/AlmaLinux-9-GenericCloud-latest.x86_64.qcow2 600m
    # https://download.rockylinux.org/pub/rocky/9/images/x86_64/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2 600m
    # https://yum.oracle.com/templates/OracleLinux/OL9/u3/x86_64/OL9U3_x86_64-kvm-b220.qcow2 600m
    # https://rhel-9.4-x86_64-kvm.qcow2 900m

    # 10
    # https://cloud.centos.org/centos/10-stream/x86_64/images/CentOS-Stream-GenericCloud-10-latest.x86_64.qcow2 900m

    # https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/cloud/nocloud_alpine-3.19.1-x86_64-uefi-cloudinit-r0.qcow2 200m
    # https://kali.download/cloud-images/current/kali-linux-2024.1-cloud-genericcloud-amd64.tar.xz 200m
    # https://download.opensuse.org/tumbleweed/appliances/openSUSE-Tumbleweed-Minimal-VM.x86_64-Cloud.qcow2 300m
    # https://download.opensuse.org/distribution/leap/15.5/appliances/openSUSE-Leap-15.5-Minimal-VM.aarch64-Cloud.qcow2 300m
    # https://mirror.fcix.net/fedora/linux/releases/40/Cloud/x86_64/images/Fedora-Cloud-Base-Generic.x86_64-40-1.14.qcow2 400m
    # https://geo.mirror.pkgbuild.com/images/latest/Arch-Linux-x86_64-cloudimg.qcow2 500m
    # https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2 500m
    # https://cloud-images.ubuntu.com/releases/24.04/release/ubuntu-24.04-server-cloudimg-amd64.img 500m
    # https://gentoo.osuosl.org/experimental/amd64/openstack/gentoo-openstack-amd64-systemd-latest.qcow2 800m

    # openeuler 是 .qcow2.xz，要解压后才知道 qcow2 大小
    if [ "$distro" = openeuler ]; then
        echo 3GiB
    elif size_bytes=$(get_http_file_size "$img"); then
        # 缩小 btrfs 需要写 qcow2 ，实测写入后只多了 1M，因此不用特殊处理
        echo "$(get_part_size_mb_for_file_size_b $size_bytes)MiB"
    else
        # 如果没获取到文件大小
        echo "Could not get cloud image size in http response." >&2
        echo 2GiB
    fi
}

chroot_dnf() {
    if is_have_cmd_on_disk /os/ dnf; then
        chroot /os/ dnf -y "$@"
    else
        chroot /os/ yum -y "$@"
    fi
}

chroot_apt_update() {
    local os_dir=$1

    current_hash=$(cat $os_dir/etc/apt/sources.list $os_dir/etc/apt/sources.list.d/*.sources 2>/dev/null | md5sum)
    if ! [ "$saved_hash" = "$current_hash" ]; then
        chroot $os_dir apt-get update
        saved_hash="$current_hash"
    fi
}

chroot_apt_install() {
    local os_dir=$1
    shift

    # 只安装未安装的软件包
    # 避免更新浪费时间
    local pkg='' pkgs=''
    for pkg in "$@"; do
        if chroot $os_dir dpkg -s "$pkg" >/dev/null 2>&1; then
            # 如果已安装则标记为 manual，防止被 autoremove 删除
            chroot $os_dir apt-mark manual "$pkg"
        else
            pkgs="$pkgs $pkg"
        fi
    done

    # 一次性安装，避免多次 update-initramfs
    if [ -n "$pkgs" ]; then
        chroot_apt_update $os_dir
        DEBIAN_FRONTEND=noninteractive chroot $os_dir apt-get install -y $pkgs
    fi
}

chroot_apt_remove() {
    local os_dir=$1
    shift

    # minimal 镜像 删除 grub-pc 时会安装 grub-efi-amd64
    # 因此需要先更新索引
    chroot_apt_update $os_dir

    # 不能用 apt remove --purge -y xxx yyy
    # 因为如果索引里没有其中一个，会报错，另一个也不会删除
    local pkgs=
    for pkg in "$@"; do
        # apt list 会提示 WARNING: apt does not have a stable CLI interface. Use with caution in scripts.
        # 但又不能用 apt-get list
        if chroot $os_dir apt list --installed "$pkg" | grep -q installed; then
            pkgs="$pkgs $pkg"
        fi
    done

    # 删除 resolvconf 时会弹出建议重启，因此添加 noninteractive
    DEBIAN_FRONTEND=noninteractive chroot $os_dir apt-get remove --purge --allow-remove-essential -y $pkgs
}

chroot_apt_autoremove() {
    local os_dir=$1

    change_confs() {
        action=$1

        file=$os_dir/etc/apt/apt.conf.d/01autoremove
        case "$action" in
        change)
            if [ -f $file ]; then
                sed -i.orig 's/VersionedKernelPackages/x/; s/NeverAutoRemove/x/' $file
            fi
            ;;
        restore)
            if [ -f $file.orig ]; then
                mv $file.orig $file
            fi
            ;;
        esac
    }

    change_confs change
    DEBIAN_FRONTEND=noninteractive chroot $os_dir apt-get autoremove --purge -y
    change_confs restore
}

del_default_user() {
    local os_dir=$1

    local user
    while read -r user; do
        if grep ^$user':\$' "$os_dir/etc/shadow"; then
            echo "Deleting user $user"
            chroot "$os_dir" userdel -rf "$user"
        fi
    done < <(grep -v nologin$ "$os_dir/etc/passwd" | cut -d: -f1 | grep -v root)
}

is_el7_family() {
    is_have_cmd_on_disk "$1" yum &&
        ! is_have_cmd_on_disk "$1" dnf
}

del_exist_sysconfig_NetworkManager_config() {
    local os_dir=$1

    # 删除云镜像自带的 dhcp 配置，防止歧义
    rm -rf $os_dir/etc/NetworkManager/system-connections/*.nmconnection
    rm -rf $os_dir/etc/sysconfig/network-scripts/ifcfg-*

    # 1. 修复 cloud-init 添加了 IPV*_FAILURE_FATAL / may-fail=false
    #    甲骨文 dhcpv6 获取不到 IP 将视为 fatal，原有的 ipv4 地址也会被删除
    # 2. 修复 dhcpv6 下，ifcfg 添加了 IPV6_AUTOCONF=no 导致无法获取网关
    # 3. 修复 dhcpv6 下，NM method=dhcp 导致无法获取网关
    if false; then
        ci_file=$os_dir/etc/cloud/cloud.cfg.d/99_fallback.cfg

        insert_into_file $ci_file after '^runcmd:' <<EOF
  - sed -i '/^IPV[46]_FAILURE_FATAL=/d' /etc/sysconfig/network-scripts/ifcfg-* || true
  - sed -i '/^may-fail=/d' /etc/NetworkManager/system-connections/*.nmconnection || true
  - for f in /etc/sysconfig/network-scripts/ifcfg-*; do grep -q '^DHCPV6C=yes' "\$f" && sed -i '/^IPV6_AUTOCONF=no/d' "\$f"; done
  - sed -i 's/^method=dhcp/method=auto/' /etc/NetworkManager/system-connections/*.nmconnection || true
  - systemctl is-enabled NetworkManager && systemctl restart NetworkManager || true
EOF
    fi
}

install_fnos() {
    info "Install fnos/fygoos"
    local os_dir=/os

    # 官方安装调用流程
    # /etc/init.d/run_install.sh > trim-install > trim-grub

    # 挂载 /os
    mkdir -p /os
    mount "/dev/$(xda 2)" /os

    # 下载并挂载 iso
    mkdir -p /os/installer /iso
    download "$iso" /os/installer/fnos.iso
    mount -o ro /os/installer/fnos.iso /iso

    # 解压 initrd
    apk add cpio
    initrd_dir=/os/installer/initrd_dir
    mkdir -p $initrd_dir
    (
        cd $initrd_dir
        suffix=$(
            case $(uname -m) in
            x86_64) echo amd ;;
            aarch64) echo a64 ;;
            *) ;;
            esac
        )
        zcat /iso/install.$suffix/initrd.gz | cpio -idm
    )
    apk del cpio

    # 获取挂载参数
    fstab_line_os=$(strings $initrd_dir/trim-install | grep -m1 '^UUID=%s / ')
    fstab_line_efi=$(strings $initrd_dir/trim-install | grep -m1 '^UUID=%s /boot/efi ')
    fstab_line_swapfile=$(strings $initrd_dir/trim-install | grep -m1 '^/swapfile none swap ')

    # 删除 initrd
    rm -rf $initrd_dir

    # 复制 trimfs.tgz 并删除 ISO 以获得更多空间
    echo "moving trimfs.tgz..."
    cp /iso/trimfs.tgz /os/installer
    umount /iso
    rm /os/installer/fnos.iso

    # 挂载 /os/boot/efi
    if is_efi; then
        mkdir -p /os/boot/efi
        mount -o "$(echo "$fstab_line_efi" | awk '{print $4}')" "/dev/$(xda 1)" /os/boot/efi
    fi

    # 复制系统
    info "Extract fnos/fygoos"
    apk add tar gzip pv
    pv -f /os/installer/trimfs.tgz | tar zxp --numeric-owner --xattrs-include='*.*' -C /os
    apk del tar gzip pv

    # 删除 installer (trimfs.tgz)
    rm -rf /os/installer

    # 缩小分区
    if $NEED_SHRINK_FNOS_OS_PART; then
        info "Shrink fnos/fygoos os partition"

        # 取消挂载
        if is_efi; then
            umount /os/boot/efi
        fi
        umount /os

        # 101M 是 efi + bios_grub 分区，即使 bios 引导飞牛官方安装器也会生成一个 100M 预留分区
        # 99M 是预留的文件系统和分区表的差值
        # 一共 200M
        apk add e2fsprogs-extra parted
        e2fsck -p -f "/dev/$(xda 2)"
        resize2fs "/dev/$(xda 2)" "$((FNOS_OS_PART_END_M - 200))M"
        update_part
        printf "yes" | parted /dev/$xda resizepart 2 "$((FNOS_OS_PART_END_M))MiB" ---pretend-input-tty
        update_part
        resize2fs "/dev/$(xda 2)"
        update_part
        apk del e2fsprogs-extra parted

        # 重新挂载
        mount "/dev/$(xda 2)" /os
        if is_efi; then
            mount -o "$(echo "$fstab_line_efi" | awk '{print $4}')" "/dev/$(xda 1)" /os/boot/efi
        fi
    fi

    # 挂载 proc sys dev
    mount_pseudo_fs /os

    # 更改密码
    if false; then
        if is_need_set_ssh_keys; then
            set_ssh_keys_and_del_password $os_dir
        else
            change_user_password $os_dir
        fi
    fi

    # ssh root 登录，测试用
    if false; then
        if is_need_set_ssh_keys; then
            change_ssh_conf_for_key_login $os_dir
        else
            change_ssh_conf_for_password_login $os_dir
        fi
        chroot $os_dir systemctl enable ssh
    fi

    # fstab
    {
        # /
        uuid=$(lsblk "/dev/$(xda 2)" -no UUID)
        echo "$fstab_line_os" | sed "s/%s/$uuid/"

        # swapfile
        # 官方安装器即使 swapfile 设为 0 也会有这行
        echo "$fstab_line_swapfile"

        # /boot/efi
        if is_efi; then
            uuid=$(lsblk "/dev/$(xda 1)" -no UUID)
            echo "$fstab_line_efi" | sed "s/%s/$uuid/"
        fi
    } >$os_dir/etc/fstab

    # 更新 initrd，官方安装器也有这一步
    # 理论上 /var/tmp 要设置 1777 权限，但飞牛官方安装器安装后不是
    # 需要先创建 /etc/fstab ，否则会有以下警告
    # W: Couldn't identify type of root file system for fsck hook
    mkdir -p $os_dir/var/tmp
    chmod 1777 $os_dir/var/tmp
    chroot $os_dir update-initramfs -u

    # grub
    if is_efi; then
        chroot $os_dir grub-install --efi-directory=/boot/efi
        chroot $os_dir grub-install --efi-directory=/boot/efi --removable
    else
        chroot $os_dir grub-install /dev/$xda
    fi

    # grub 配置
    # strings trim-install | grep GRUB_DISTRIBUTOR
    # 国内版得到的是 sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="FNOS"/' /mnt/rootfs/etc/default/grub
    # 国际版得到的是 sed -i 's/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR="%s"/' /mnt/rootfs/etc/default/grub
    # 因此这里写死
    if grep -Fq fygonas.com $os_dir/etc/apt/sources.list.d/trim_repo.list; then
        name_for_grub=FygoOS
    elif grep -Fq fnnas.com $os_dir/etc/apt/sources.list.d/trim_repo.list; then
        name_for_grub=FNOS
    else
        error_and_exit 'Can not detect FNOS/FygoOS.'
    fi
    sed -i "s/^GRUB_DISTRIBUTOR=.*/GRUB_DISTRIBUTOR=\"$name_for_grub\"/" $os_dir/etc/default/grub

    # grub tty
    ttys_cmdline=$(get_ttys console=)
    echo GRUB_CMDLINE_LINUX=\"\$GRUB_CMDLINE_LINUX $ttys_cmdline\" >$os_dir/etc/default/grub.d/tty.cfg

    chroot $os_dir update-grub

    # 网卡配置
    create_cloud_init_network_config /net.cfg
    create_network_manager_config /net.cfg $os_dir
    rm /net.cfg

    # 修正网卡名
    add_fix_eth_name_systemd_service $os_dir

    # frpc
    add_frpc_systemd_service_if_need $os_dir
}

install_qcow_by_copy() {
    info "Install qcow2 by copy"

    modify_el_ol() {
        info "Modify el ol"
        local os_dir=/os

        # resolv.conf
        cp_resolv_conf /os

        # 部分镜像有默认配置，例如 centos
        del_exist_sysconfig_NetworkManager_config /os

        # 删除镜像的默认账户，防止使用默认账户密码登录 ssh
        del_default_user /os

        # selinux kdump
        disable_selinux /os
        disable_kdump /os

        # el7 删除 machine-id 后不会自动重建
        clear_machine_id /os

        # el7 forks 特殊处理
        if is_el7_family /os; then
            # centos 7 eol 换源
            if [ -f /os/etc/yum.repos.d/CentOS-Base.repo ]; then
                # 保持默认的 http 因为自带的 ssl 证书可能过期
                if is_in_china; then
                    mirror=mirror.nju.edu.cn/centos-vault
                else
                    mirror=vault.centos.org
                fi
                sed -Ei -e 's,(mirrorlist=),#\1,' \
                    -e "s,#(baseurl=http://)mirror.centos.org,\1$mirror," /os/etc/yum.repos.d/CentOS-Base.repo
            fi

            # el7 yum 可能会使用 ipv6，即使没有 ipv6 网络
            if [ "$(cat /dev/netconf/*/ipv6_has_internet | sort -u)" = 0 ]; then
                echo 'ip_resolve=4' >>/os/etc/yum.conf
            fi

            # el7 安装 NetworkManager
            # anolis 7 镜像自带 NetworkManager
            if ! [ -f /os/usr/lib/systemd/system/NetworkManager.service ]; then
                chroot_dnf install NetworkManager
            fi
            # 服务不存在时会报错
            chroot /os systemctl disable network 2>/dev/null || true
            chroot /os systemctl enable NetworkManager
        fi

        # firmware + microcode
        if fw_pkgs=$(get_ucode_firmware_pkgs) && [ -n "$fw_pkgs" ]; then
            chroot_dnf install $fw_pkgs
        fi

        # fstab 删除多余分区
        # almalinux/rocky 镜像有 boot 分区
        # oracle 镜像有 swap 分区
        sed -i '/[[:space:]]\/boot[[:space:]]/d' /os/etc/fstab
        sed -i '/[[:space:]]swap[[:space:]]/d' /os/etc/fstab

        # os_part 变量:
        # mapper/vg_main-lv_root
        # mapper/opencloudos-root

        # oracle/opencloudos 系统盘从 lvm 改成 uuid 挂载
        sed -i "s,/dev/$os_part,UUID=$os_part_uuid," /os/etc/fstab
        if ls /os/boot/loader/entries/*.conf 2>/dev/null; then
            # options root=/dev/mapper/opencloudos-root ro console=ttyS0,115200n8 no_timer_check net.ifnames=0 crashkernel=1800M-64G:256M,64G-128G:512M,128G-486G:768M,486G-972G:1024M,972G-:2048M rd.lvm.lv=opencloudos/root rhgb quiet
            sed -i "s,/dev/$os_part,UUID=$os_part_uuid," /os/boot/loader/entries/*.conf
        fi

        # oracle/opencloudos 移除 lvm cmdline
        chroot /os grubby --update-kernel ALL --remove-args "resume rd.lvm.lv"
        # el7 上面那条 grubby 命令不能设置 /etc/default/grub
        sed -i 's/rd.lvm.lv=[^ "]*//g' /os/etc/default/grub

        # fstab 添加 efi 分区
        if is_efi; then
            # centos/oracle 要创建efi条目
            if ! grep /boot/efi /os/etc/fstab; then
                efi_part_uuid=$(lsblk "/dev/$(xda 1)" -no UUID)
                echo "UUID=$efi_part_uuid /boot/efi vfat $efi_mount_opts 0 0" >>/os/etc/fstab
            fi
        else
            # 删除 efi 条目
            sed -i '/[[:space:]]\/boot\/efi[[:space:]]/d' /os/etc/fstab
        fi

        remove_grub_conflict_files() {
            # bios 和 efi 转换前先删除

            # bios转efi出错
            # centos 和 oracle x86_64 镜像只有 bios 镜像，/boot/grub2/grubenv 是真身
            # 安装grub-efi时，grubenv 会改成指向efi分区grubenv软连接
            # 如果安装grub-efi前没有删除原来的grubenv，原来的grubenv将不变，新建的软连接将变成 grubenv.rpmnew
            # 后续grubenv的改动无法同步到efi分区，会造成grub2-setdefault失效

            # efi转bios出错
            # 如果是指向efi目录的软连接（例如el8），先删除它，否则 grub2-install 会报错
            rm -rf /os/boot/grub2/grubenv /os/boot/grub2/grub.cfg
        }

        # openeuler arm 镜像 grub.cfg 在 /os/grub.cfg，可能给外部的 grub 读取，我们用不到
        # centos7 有 grub1 的配置
        rm -rf /os/grub.cfg /os/boot/grub/grub.conf /os/boot/grub/menu.lst

        # 安装引导
        if is_efi; then
            # 只有centos 和 oracle x86_64 镜像没有efi，其他系统镜像已经从efi分区复制了文件
            # openeuler 自带 grub2-efi-ia32，此时安装 grub2-efi 提示已经安装了 grub2-efi-ia32，不会继续安装 grub2-efi-x64

            # 假设极端情况，qcow2 制作时，安装 grub2-efi-x64 时没有挂载 efi 分区，那么 efi 文件会在系统分区下
            # 但我们复制系统分区时挂载了 /boot/efi，因此 efi 文件会正确地复制到 efi 分区
            # 因此无需判断 qcow2 的 efi 是否是独立分区

            # rhel 镜像没有源，直接 yum install 安装可能会报错
            # 因此如果已经安装了要用的包就不再运行 yum install
            need_install=false
            need_remove_grub_conflict_files=false

            [ "$(uname -m)" = x86_64 ] && arch=x64 || arch=aa64
            if ! chroot $os_dir rpm -qi grub2-efi-$arch; then
                need_install=true
                need_remove_grub_conflict_files=true
            elif ! chroot $os_dir rpm -qi shim-$arch || ! chroot $os_dir rpm -qi efibootmgr; then
                need_install=true
            fi

            if $need_install; then
                if $need_remove_grub_conflict_files; then
                    remove_grub_conflict_files
                fi
                chroot_dnf install efibootmgr grub2-efi-$arch shim-$arch
            fi

            # openeuler arm 云镜像里面的 grubaa64.efi 有问题

            # 1. 会自动进入 rescue 模式
            # set 命令输出如下
            # fw_path='(hd0,gpt1)//EFI/openEuler'
            # prefix='(hd0,msdos1)/efi/EFI/openEuler'
            # root='hd0,msdos1'
            # 将 msdos1 改成 gpt1 后才能加载 normal 正常引导

            # 2. 不是来自 grub2-efi-aa64 rpm
            # 因此重新下载 $root 是 hd0,gpt1 的 grubaa64.efi
            if $need_reinstall_grub_efi; then
                chroot_dnf reinstall grub2-efi-$arch
            fi
        else
            # bios
            remove_grub_conflict_files
            chroot /os/ grub2-install /dev/$xda
        fi

        # blscfg 启动项
        # rocky/almalinux镜像是独立的boot分区，但我们不是
        # 因此要添加boot目录
        if ls /os/boot/loader/entries/*.conf 2>/dev/null &&
            ! grep -q 'initrd /boot/' /os/boot/loader/entries/*.conf; then

            sed -i -E 's,((linux|initrd) /),\1boot/,g' /os/boot/loader/entries/*.conf
        fi

        # grub-efi-x64 包里面有 /etc/grub2-efi.cfg
        # 指向 /boot/efi/EFI/xxx/grub.cfg 或 /boot/grub2/grub.cfg
        # 指向哪里哪里就是 grub2-mkconfig 应该生成文件的位置
        # grubby 也是靠 /etc/grub2-efi.cfg 定位 grub.cfg 的位置
        # openeuler 24.03 x64 aa64 指向的文件不同
        if is_efi; then
            grub_o_cfg=$(chroot /os readlink -f /etc/grub2-efi.cfg)
        else
            grub_o_cfg=/boot/grub2/grub.cfg
        fi

        # efi 分区 grub.cfg
        # https://github.com/rhinstaller/anaconda/blob/346b932a26a19b339e9073c049b08bdef7f166c3/pyanaconda/modules/storage/bootloader/efi.py#L198
        # https://github.com/rhinstaller/anaconda/commit/15c3b2044367d375db6739e8b8f419ef3e17cae7
        if is_efi && ! echo "$grub_o_cfg" | grep -q '/boot/efi/EFI'; then
            # oracle linux 文件夹是 redhat
            # shellcheck disable=SC2010
            distro_efi=$(cd /os/boot/efi/EFI/ && ls -d -- * | grep -Eiv BOOT)
            cat <<EOF >/os/boot/efi/EFI/$distro_efi/grub.cfg
search --no-floppy --fs-uuid --set=dev $os_part_uuid
set prefix=(\$dev)/boot/grub2
export \$prefix
configfile \$prefix/grub.cfg
EOF
        fi

        # 主 grub.cfg
        if ls /os/boot/loader/entries/*.conf >/dev/null 2>&1 &&
            chroot /os/ grub2-mkconfig --help | grep -q update-bls-cmdline; then
            chroot /os/ grub2-mkconfig -o "$grub_o_cfg" --update-bls-cmdline
        else
            chroot /os/ grub2-mkconfig -o "$grub_o_cfg"
        fi

        # 网络配置
        # el7/8 sysconfig
        # el9 network-manager
        if [ -f $os_dir/etc/sysconfig/network-scripts/ifup-eth ]; then
            # sysconfig
            info 'sysconfig'

            # 使用目标系统内的 cloud-init
            # 保留这个，防止未来新版本 cloud-init 不支持 sysconfig
            if false; then
                # anolis/openeuler/opencloudos 可能要安装 cloud-init
                # opencloudos 无法使用 chroot $os_dir command -v xxx
                # chroot: failed to run command ‘command’: No such file or directory
                # 注意还要禁用 cloud-init 服务
                if ! is_have_cmd_on_disk $os_dir cloud-init; then
                    chroot_dnf install cloud-init
                fi

                # cloud-init 路径
                # /usr/lib/python2.7/site-packages/cloudinit/net/
                # /usr/lib/python3/dist-packages/cloudinit/net/
                # /usr/lib/python3.9/site-packages/cloudinit/net/

                # el7 不认识 static6，但可改成 static，作用相同
                recognize_static6=true
                if ls $os_dir/usr/lib/python*/*-packages/cloudinit/net/sysconfig.py 2>/dev/null &&
                    ! grep -q static6 $os_dir/usr/lib/python*/*-packages/cloudinit/net/sysconfig.py; then
                    recognize_static6=false
                fi

                # cloud-init 20.1 才支持以下配置
                # https://cloudinit.readthedocs.io/en/20.4/topics/network-config-format-v1.html#subnet-ip
                # https://cloudinit.readthedocs.io/en/21.1/topics/network-config-format-v1.html#subnet-ip
                # ipv6_dhcpv6-stateful: Configure this interface with dhcp6
                # ipv6_dhcpv6-stateless: Configure this interface with SLAAC and DHCP
                # ipv6_slaac: Configure address with SLAAC

                # el7 最新 cloud-init 版本
                # centos 7         19.4-7.0.5.el7_9.6  backport 了 ipv6_xxx
                # openeuler 20.03  19.4-15.oe2003sp4   backport 了 ipv6_xxx
                # anolis 7         19.1.17-1.0.1.an7   没有更新到 centos7 相同版本,也没 backport ipv6_xxx，坑

                # 最好还修改 ifcfg-eth* 的 IPV6_AUTOCONF
                # 但实测 anolis7 cloud-init dhcp6 不会生成 IPV6_AUTOCONF，因此暂时不管
                # https://www.redhat.com/zh/blog/configuring-ipv6-rhel-7-8
                recognize_ipv6_types=true
                if ls -d $os_dir/usr/lib/python*/*-packages/cloudinit/net/ 2>/dev/null &&
                    ! grep -qr ipv6_slaac $os_dir/usr/lib/python*/*-packages/cloudinit/net/; then
                    recognize_ipv6_types=false
                fi

                # 生成 cloud-init 网络配置
                create_cloud_init_network_config $os_dir/net.cfg "$recognize_static6" "$recognize_ipv6_types"

                # 转换成目标系统的网络配置
                chroot $os_dir cloud-init devel net-convert \
                    -p /net.cfg -k yaml -d out -D rhel -O sysconfig
                cp $os_dir/out/etc/sysconfig/network-scripts/ifcfg-eth* $os_dir/etc/sysconfig/network-scripts/

                # 清理
                rm -rf $os_dir/net.cfg $os_dir/out
            else
                # 使用 alpine 的 cloud-init

                # 生成 cloud-init 网络配置
                create_cloud_init_network_config net.cfg

                # 转换成目标系统的网络配置
                apk add cloud-init-distros
                cloud-init devel net-convert \
                    -p /net.cfg -k yaml -d out -D rhel -O sysconfig
                cp out/etc/sysconfig/network-scripts/ifcfg-eth* $os_dir/etc/sysconfig/network-scripts/

                # 清理
                rm -rf net.cfg out
                apk del cloud-init-distros
            fi

            # 删除 # Created by cloud-init on instance boot automatically, do not edit.
            # 修正网络配置问题并显示文件
            sed -i -e '/^IPV[46]_FAILURE_FATAL=/d' -e '/^#/d' $os_dir/etc/sysconfig/network-scripts/ifcfg-*
            for file in "$os_dir/etc/sysconfig/network-scripts/ifcfg-"*; do
                if grep -q '^DHCPV6C=yes' "$file"; then
                    sed -i '/^IPV6_AUTOCONF=no/d' "$file"
                fi
                cat -n "$file"
            done
        else
            # Network Manager
            info 'Network Manager'

            create_cloud_init_network_config /net.cfg
            create_network_manager_config /net.cfg "$os_dir"

            # 清理
            rm /net.cfg
        fi

        # 不删除可能网络管理器不会写入dns
        rm_resolv_conf /os
    }

    modify_ubuntu() {
        local os_dir=/os
        info "Modify Ubuntu"

        cp_resolv_conf $os_dir

        # 关闭 os prober，因为 os prober 有时很慢
        cp $os_dir/etc/default/grub $os_dir/etc/default/grub.orig
        echo 'GRUB_DISABLE_OS_PROBER=true' >>$os_dir/etc/default/grub

        # 更改源
        if is_in_china; then
            # 22.04 使用 /etc/apt/sources.list
            # 24.04 使用 /etc/apt/sources.list.d/ubuntu.sources
            for file in $os_dir/etc/apt/sources.list $os_dir/etc/apt/sources.list.d/ubuntu.sources; do
                if [ -f $file ]; then
                    # cn.archive.ubuntu.com 不在国内还严重丢包
                    # https://www.itdog.cn/ping/cn.archive.ubuntu.com
                    sed -i 's/archive.ubuntu.com/mirror.nju.edu.cn/' $file # x64
                    sed -i 's/ports.ubuntu.com/mirror.nju.edu.cn/' $file   # arm
                fi
            done
        fi

        # 避免 do-release-upgrade 时自动执行 dpkg-reconfigure grub-xx 但是 efi/biosgrub 分区不存在而导致报错
        # shellcheck disable=SC2046
        chroot_apt_remove $os_dir $(is_efi && echo 'grub-pc' || echo 'grub-efi*' 'shim*')
        chroot_apt_autoremove $os_dir

        # 安装 mbr
        if ! is_efi; then
            if false; then
                # debconf-show grub-pc
                # 每次开机硬盘名字可能不一样，但是 debian netboot 安装后也是设置了 grub-pc/install_devices
                echo grub-pc grub-pc/install_devices multiselect /dev/$xda | chroot $os_dir debconf-set-selections # 22.04
                echo grub-pc grub-pc/cloud_style_installation boolean true | chroot $os_dir debconf-set-selections # 24.04
                chroot $os_dir dpkg-reconfigure -f noninteractive grub-pc
            else
                chroot $os_dir grub-install /dev/$xda
            fi
        fi

        # 自带内核：
        # 常规版本             generic
        # minimal 20.04/22.04 kvm      # 后台 vnc 无显示
        # minimal 24.04       virtual

        # debian cloud 内核不支持 ahci，ubuntu virtual 支持

        # 标记所有内核为自动安装
        # 注意排除 linux-base
        # 返回值始终为 0
        pkgs=$(chroot $os_dir apt-mark showmanual \
            linux-generic linux-virtual linux-kvm \
            linux-image* linux-headers*)
        chroot $os_dir apt-mark auto $pkgs

        # 安装最佳内核
        flavor=$(get_ubuntu_kernel_flavor)
        echo "Use kernel flavor: $flavor"

        # 题外话
        # 如果某个包是 auto 状态且有更新
        # 则 apt install PKG 只会进行更新，不会将包设置成 manual
        # 需要再次运行 apt install PKG 才会将包设置成 manual

        # 该方法包含了 apt-mark manual
        chroot_apt_install $os_dir "linux-image-$flavor"

        # 使用 autoremove 删除多余内核
        chroot_apt_autoremove $os_dir

        # 安装固件+微码
        if fw_pkgs=$(get_ucode_firmware_pkgs) && [ -n "$fw_pkgs" ]; then
            chroot_apt_install $os_dir $fw_pkgs
        fi

        # 网络配置
        # 18.04+ netplan
        # 避免删除 cloud-init 后，minimal 镜像的 netplan.io 被 autoremove
        chroot $os_dir apt-mark manual netplan.io

        # 生成 cloud-init 网络配置
        create_cloud_init_network_config $os_dir/net.cfg

        # ubuntu 18.04 cloud-init 版本 23.1.2，因此不用处理 onlink

        # 如果不是输出到 / 则不会生成 50-cloud-init.yaml
        # 注意比较多了什么东西
        if false; then
            chroot $os_dir cloud-init devel net-convert \
                -p /net.cfg -k yaml -d /out -D ubuntu -O netplan
            sed -Ei "/^[[:space:]]+set-name:/d" $os_dir/out/etc/netplan/50-cloud-init.yaml
            cp $os_dir/out/etc/netplan/50-cloud-init.yaml $os_dir/etc/netplan/

            # 清理
            rm -rf $os_dir/net.cfg $os_dir/out
        else
            chroot $os_dir cloud-init devel net-convert \
                -p /net.cfg -k yaml -d / -D ubuntu -O netplan
            sed -Ei "/^[[:space:]]+set-name:/d" $os_dir/etc/netplan/50-cloud-init.yaml

            # 清理
            rm -rf $os_dir/net.cfg
        fi

        # 自带的 60-cloudimg-settings.conf 禁止了 PasswordAuthentication
        # 可删除可不删除，因为现在会先读取有效 sshd 配置再修改 sshd 配置
        # 如果要删除 60-cloudimg-settings.conf 则要在 change_ssh_conf_if_different 之前删除
        if false; then
            file=$os_dir/etc/ssh/sshd_config.d/60-cloudimg-settings.conf
            if [ -f $file ]; then
                sed -i '/^PasswordAuthentication/d' $file
                if [ -z "$(cat $file)" ]; then
                    rm -f $file
                fi
            fi
        fi

        # 更改 efi 目录的 grub.cfg 写死的 fsuuid
        # 因为 24.04 fsuuid 对应 boot 分区
        efi_grub_cfg=$os_dir/boot/efi/EFI/ubuntu/grub.cfg
        if is_efi; then
            os_uuid=$(lsblk -rno UUID "/dev/$(xda 2)")
            sed -Ei "s|[0-9a-f-]{36}|$os_uuid|i" $efi_grub_cfg

            # 24.04 移除 boot 分区后，需要添加 /boot 路径
            if grep "'/grub'" $efi_grub_cfg; then
                sed -i "s|'/grub'|'/boot/grub'|" $efi_grub_cfg
            fi
        fi

        # 处理 40-force-partuuid.cfg
        force_partuuid_cfg=$os_dir/etc/default/grub.d/40-force-partuuid.cfg
        if [ -e $force_partuuid_cfg ]; then
            if is_virt; then
                # 更改写死的 partuuid
                os_part_uuid=$(lsblk -rno PARTUUID "/dev/$(xda 2)")
                sed -i "s/^GRUB_FORCE_PARTUUID=.*/GRUB_FORCE_PARTUUID=$os_part_uuid/" $force_partuuid_cfg
            else
                # 独服不应该使用 initrdless boot
                sed -i "/^GRUB_FORCE_PARTUUID=/d" $force_partuuid_cfg
            fi
        fi

        # 要重新生成 grub.cfg，因为
        # 1 我们删除了 boot 分区
        # 2 改动了 /etc/default/grub.d/40-force-partuuid.cfg
        chroot $os_dir update-grub

        # 还原 grub 配置（os prober）
        mv $os_dir/etc/default/grub.orig $os_dir/etc/default/grub

        # fstab
        # 24.04 镜像有boot分区，但我们不需要
        sed -i '/[[:space:]]\/boot[[:space:]]/d' $os_dir/etc/fstab
        if ! is_efi; then
            # bios 删除 efi 条目
            sed -i '/[[:space:]]\/boot\/efi[[:space:]]/d' $os_dir/etc/fstab
        fi

        restore_resolv_conf $os_dir
    }

    efi_mount_opts=$(
        case "$distro" in
        ubuntu) echo "umask=0077" ;;
        *) echo "defaults,uid=0,gid=0,umask=077,shortname=winnt" ;;
        esac
    )

    # yum/apt 安装软件时需要的内存总大小
    need_ram=$(
        case "$distro" in
        ubuntu) echo 1024 ;;
        *) echo 2048 ;;
        esac
    )

    connect_qcow

    # 镜像分区格式
    # centos/rocky/almalinux/rhel: xfs
    # oracle x86_64:          lvm + xfs
    # oracle aarch64 cloud:   xfs
    # openeuler x64/arm:      mbr 分区表 + ext4
    # alibaba cloud linux 3:  ext4

    is_lvm_image=false
    if lsblk -f /dev/nbd0p* | grep LVM2_member; then
        is_lvm_image=true
        apk add lvm2
        lvscan
        vg=$(pvs | grep /dev/nbd0p | awk '{print $2}')
        lvchange -ay "$vg"
    fi

    mount_nouuid() {
        part_fstype=
        for arg in "$@"; do
            case "$arg" in
            /dev/*)
                part_fstype=$(lsblk -no FSTYPE "$arg")
                break
                ;;
            esac
        done

        case "$part_fstype" in
        xfs) mount -o nouuid "$@" ;;
        *) mount "$@" ;;
        esac
    }

    # 可以直接选择最后一个分区为系统分区?
    # almalinux9 boot 分区的类型不是规定的 uuid
    # openeuler boot 分区是 vfat 格式
    # openeuler arm 25.09 是 mbr 分区表, efi boot 是同一个分区，vfat 格式

    info "qcow2 Partitions check"

    # 检测分区表类型
    partition_table_format=$(get_partition_table_format /dev/nbd0)
    need_reinstall_grub_efi=false
    if is_efi && [ "$partition_table_format" = "msdos" ]; then
        need_reinstall_grub_efi=true
    fi

    # 通过检测文件判断是什么分区
    os_part='' boot_part='' efi_part=''
    mkdir -p /nbd-test
    for part in $(lsblk /dev/nbd0p* --sort SIZE -no NAME,FSTYPE |
        grep -E ' (ext4|xfs|fat|vfat)$' | awk '{print $1}' | tac); do
        mapper_part=$part
        if $is_lvm_image && [ -e /dev/mapper/$part ]; then
            mapper_part=mapper/$part
        fi

        if mount_nouuid -o ro /dev/$mapper_part /nbd-test; then
            if { ls /nbd-test/etc/os-release || ls /nbd-test/*/etc/os-release; } 2>/dev/null; then
                os_part=$mapper_part
            fi
            # shellcheck disable=SC2010
            # 当 boot 作为独立分区时，vmlinuz 等文件在根目录
            # 当 boot 不是独立分区时，vmlinuz 等文件在 /boot 目录
            if ls /nbd-test/ /nbd-test/boot/ 2>/dev/null | grep -Ei '^(vmlinuz|initrd|initramfs)'; then
                boot_part=$mapper_part
            fi
            # mbr + efi 引导 ，分区表没有 esp guid
            # 因此需要用 efi 文件判断是否 efi 分区
            # efi 文件可能在 efi 目录的子目录，子目录层数不定
            if find /nbd-test/ -type f -ipath '/nbd-test/EFI/*.efi' 2>/dev/null | grep .; then
                efi_part=$mapper_part
            fi
            umount /nbd-test
        fi
    done

    info "qcow2 Partitions"
    lsblk -f /dev/nbd0 -o +PARTTYPE
    # 显示 OS/EFI/Boot 文件在哪个分区
    echo "---"
    echo "Table:     $partition_table_format"
    echo "Part OS:   $os_part"
    echo "Part EFI:  $efi_part"
    echo "Part Boot: $boot_part"
    echo "---"

    # 分区寻找方式
    # 系统/分区          cmdline:root  fstab:efi
    # rocky             LABEL=rocky   LABEL=EFI
    # ubuntu            PARTUUID      LABEL=UEFI
    # 其他el/ol         UUID           UUID

    IFS=, read -r os_part_uuid os_part_label os_part_fstype \
        < <(lsblk /dev/$os_part -rno UUID,LABEL,FSTYPE | tr ' ' ,)

    if [ -n "$efi_part" ]; then
        IFS=, read -r efi_part_uuid efi_part_label \
            < <(lsblk /dev/$efi_part -rno UUID,LABEL | tr ' ' ,)
    fi

    mkdir -p /nbd /nbd-boot /nbd-efi

    # 使用目标系统的格式化程序
    # centos8 如果用alpine格式化xfs，grub2-mkconfig和grub2里面都无法识别xfs分区
    mount_nouuid /dev/$os_part /nbd/
    mount_pseudo_fs /nbd/
    case "$os_part_fstype" in
    ext4) chroot /nbd mkfs.ext4 -F -L "$os_part_label" -U "$os_part_uuid" "/dev/$(xda 2)" ;;
    xfs) chroot /nbd mkfs.xfs -f -L "$os_part_label" -m uuid=$os_part_uuid "/dev/$(xda 2)" ;;
    esac
    umount -R /nbd/

    # TODO: ubuntu 镜像缺少 mkfs.fat/vfat/dosfstools? initrd 不需要检查fs完整性？

    # 创建并挂载 /os
    mkdir -p /os
    mount -o noatime "/dev/$(xda 2)" /os/

    # 如果是 efi 则创建 /os/boot/efi
    # 如果镜像有 efi 分区也创建 /os/boot/efi，用于复制 efi 分区的文件
    if is_efi || [ -n "$efi_part" ]; then
        mkdir -p /os/boot/efi/

        # 挂载 /os/boot/efi
        # 预先挂载 /os/boot/efi 因为可能 boot 和 efi 在同一个分区（openeuler 24.03 arm）
        # 复制 boot 时可以会复制 efi 的文件
        if is_efi; then
            mount -o $efi_mount_opts "/dev/$(xda 1)" /os/boot/efi/
        fi
    fi

    # 复制系统分区
    echo Copying os partition...
    mount_nouuid -o ro /dev/$os_part /nbd/
    cp -a /nbd/* /os/
    umount /nbd/

    # 复制独立的boot分区，如果有
    if [ -n "$boot_part" ] && ! [ "$boot_part" = "$os_part" ]; then
        echo Copying boot partition...
        mount_nouuid -o ro /dev/$boot_part /nbd-boot/
        cp -a /nbd-boot/* /os/boot/
        umount /nbd-boot/
    fi

    # 复制独立的efi分区，如果有
    # 如果 efi 和 boot 是同一个分区，则复制 boot 分区时已经复制了 efi 分区的文件
    if [ -n "$efi_part" ] && ! [ "$efi_part" = "$os_part" ] && ! [ "$efi_part" = "$boot_part" ]; then
        echo Copying efi partition...
        mount -o ro /dev/$efi_part /nbd-efi/
        cp -a /nbd-efi/* /os/boot/efi/
        umount /nbd-efi/
    fi

    # 断开 qcow 并删除 qemu-img
    info "Disconnecting qcow2"
    if is_have_cmd vgchange; then
        vgchange -an
        apk del lvm2
    fi
    disconnect_qcow
    apk del qemu-img

    # 取消挂载硬盘
    info "Unmounting disk"
    if is_efi; then
        umount /os/boot/efi/
    fi
    umount /os/
    umount /installer/

    # 如果镜像有独立的efi分区（包括efi+boot在同一个分区），复制其uuid
    # 如果有相同uuid的fat分区，则无法挂载
    # 所以要先复制efi分区，断开nbd再复制uuid
    # 复制uuid前要取消挂载硬盘 efi 分区
    if is_efi && [ -n "$efi_part_uuid" ] && ! [ "$efi_part" = "$os_part" ]; then
        info "Copy efi partition uuid"
        apk add mtools
        mlabel -N "$(echo $efi_part_uuid | sed 's/-//')" -i "/dev/$(xda 1)" ::$efi_part_label
        apk del mtools
        update_part
    fi

    # 删除 installer 分区并扩容
    info "Delete installer partition"
    apk add parted
    parted /dev/$xda -s -- rm 3
    update_part
    resize_after_install_cloud_image

    # 重新挂载 /os /boot/efi
    info "Re-mount disk"
    mount -o noatime "/dev/$(xda 2)" /os/
    if is_efi; then
        mount -o $efi_mount_opts "/dev/$(xda 1)" /os/boot/efi/
    fi

    # 创建 swap
    create_swap_if_ram_less_than $need_ram /os/swapfile

    # 挂载伪文件系统
    mount_pseudo_fs /os/

    case "$distro" in
    ubuntu) modify_ubuntu ;;
    *) modify_el_ol ;;
    esac

    # 基本配置
    basic_init /os

    # 最后才删除 cloud-init
    # 因为生成 netplan/sysconfig 网络配置要用目标系统的 cloud-init
    remove_or_disable_cloud_init /os

    # 删除 swapfile
    swapoff -a
    rm -f /os/swapfile
}

get_partition_table_format() {
    apk add parted
    parted "$1" -s print | grep 'Partition Table:' | awk '{print $NF}'
}

dd_qcow() {
    info "DD qcow2"

    if true; then
        connect_qcow

        partition_table_format=$(get_partition_table_format /dev/nbd0)
        orig_nbd_virtual_size=$(get_disk_size /dev/nbd0)

        # 检查最后一个分区是否是 btrfs
        # 即使awk结果为空，返回值也是0，加上 grep . 检查是否结果为空
        if part_num=$(parted /dev/nbd0 -s print | awk NF | tail -1 | grep btrfs | awk '{print $1}' | grep .); then
            apk add btrfs-progs
            mkdir -p /mnt/btrfs
            mount /dev/nbd0p$part_num /mnt/btrfs

            # 回收空数据块
            btrfs device usage /mnt/btrfs
            btrfs balance start -dusage=0 /mnt/btrfs
            btrfs device usage /mnt/btrfs

            # 计算可以缩小的空间
            free_bytes=$(btrfs device usage /mnt/btrfs -b | grep Unallocated: | awk '{print $2}')
            reserve_bytes=$((100 * 1024 * 1024)) # 预留 100M 可用空间
            skrink_bytes=$((free_bytes - reserve_bytes))

            if [ $skrink_bytes -gt 0 ]; then
                # 缩小文件系统
                btrfs filesystem resize -$skrink_bytes /mnt/btrfs
                # 缩小分区
                part_start=$(parted /dev/nbd0 -s 'unit b print' | awk "\$1==$part_num {print \$2}" | sed 's/B//')
                part_size=$(btrfs filesystem usage /mnt/btrfs -b | grep 'Device size:' | awk '{print $3}')
                part_end=$((part_start + part_size - 1))
                umount /mnt/btrfs
                printf "yes" | parted /dev/nbd0 resizepart $part_num ${part_end}B ---pretend-input-tty

                # 缩小 qcow2
                disconnect_qcow
                qemu-img resize --shrink $qcow_file $((part_end + 1))

                # 重新连接
                connect_qcow
            else
                umount /mnt/btrfs
            fi
        fi

        # 显示分区
        lsblk -o NAME,SIZE,FSTYPE,LABEL /dev/nbd0

        # 将前1M dd到内存
        dd if=/dev/nbd0 of=/first-1M bs=1M count=1

        # 将1M之后 dd到硬盘
        # shellcheck disable=SC2194
        case 3 in
        1)
            # BusyBox dd
            dd if=/dev/nbd0 of=/dev/$xda bs=1M skip=1 seek=1
            ;;
        2)
            # 用原版 dd status=progress，但没有进度和剩余时间
            apk add coreutils
            dd if=/dev/nbd0 of=/dev/$xda bs=1M skip=1 seek=1 status=progress
            ;;
        3)
            # 用 pv
            apk add pv
            echo "Start DD Cloud Image..."
            pv -f /dev/nbd0 | dd of=/dev/$xda bs=1M skip=1 seek=1 iflag=fullblock
            ;;
        esac

        disconnect_qcow
    else
        # 将前1M dd到内存，将1M之后 dd到硬盘
        qemu-img dd if=$qcow_file of=/first-1M bs=1M count=1
        qemu-img dd if=$qcow_file of=/dev/disk/by-label/os bs=1M skip=1
    fi

    # 已 dd 并断开连接 qcow，可删除 qemu-img
    apk del qemu-img

    # 将前1M从内存 dd 到硬盘
    umount /installer/
    dd if=/first-1M of=/dev/$xda
    rm -f /first-1M

    # gpt 分区表开头记录了备份分区表的位置
    # 如果 qcow2 虚拟容量 大于 实际硬盘容量
    # 备份分区表的位置 将超出实际硬盘容量的大小
    # partprobe 会报错
    # Error: Invalid argument during seek for read on /dev/vda
    # parted 也无法正常工作
    # 需要提前修复分区表

    # 目前只有这个例子，因为其他 qcow2 虚拟容量最多 5g，是设定支持的容量
    # openSUSE-Leap-15.5-Minimal-VM.x86_64-kvm-and-xen.qcow2 容量是 25g
    # 缩小 btrfs 分区后 dd 到 10g 的机器上
    # 备份分区表的位置是 25g
    # 需要修复到 10g 的位置上
    # 否则 partprobe parted 都无法正常工作

    # 仅这种情况才用 sgdisk 修复
    if [ "$partition_table_format" = gpt ] &&
        [ "$orig_nbd_virtual_size" -gt "$(get_disk_size /dev/$xda)" ]; then
        fix_gpt_backup_partition_table_by_sgdisk
    fi
    update_part
}

fix_gpt_backup_partition_table_by_sgdisk() {
    # 当备份分区表超出实际硬盘容量时，只能用 sgdisk 修复分区表
    # 应用场景：镜像大小超出硬盘实际硬盘，但缩小分区后不超出实际硬盘容量，可以顺利 DD
    # 例子 openSUSE-Leap-15.5-Minimal-VM.x86_64-kvm-and-xen.qcow2

    # parted 无法修复
    # parted /dev/$xda -f -s print

    # fdisk/sfdisk 显示主分区表损坏
    # echo write | sfdisk /dev/$xda
    # GPT PMBR size mismatch (50331647 != 20971519) will be corrected by write.
    # The primary GPT table is corrupt, but the backup appears OK, so that will be used.

    # 除此之外的场景应该用 parted 来修复

    apk add sgdisk

    # 两种方法都可以，但都不会修复备份分区表的 GUID
    # 此时 sgdisk -v /dev/vda 会提示主副分区表 guid 不相同
    # localhost:~# sgdisk -v /dev/$xda
    # Problem: main header's disk GUID (A24485F3-2C02-43BD-BF4E-F52E42B00DEA) doesn't
    # match the backup GPT header's disk GUID (ADAF57BC-B4F5-4E04-BCBA-BDDCD796C388)
    # You should use the 'b' or 'd' option on the recovery & transformation menu to
    # select one or the other header.
    if false; then
        sgdisk --backup /gpt-partition-table /dev/$xda
        sgdisk --load-backup /gpt-partition-table /dev/$xda
    else
        sgdisk --move-second-header /dev/$xda
    fi

    # 因此需要运行一次设置 guid
    if new_guid=$(sgdisk -v /dev/$xda | grep GUID | head -1 | grep -Eo '[0-9A-F-]{36}'); then
        sgdisk --disk-guid $new_guid /dev/$xda
    fi

    update_part

    apk del sgdisk
}

# 适用于 DD 后修复 gpt 备份分区表
fix_gpt_backup_partition_table_by_parted() {
    apk add parted
    parted /dev/$xda -f -s print
    update_part
}

resize_after_install_cloud_image() {
    # 提前扩容
    # 1 修复 vultr 512m debian 11 generic/genericcloud 首次启动 kernel panic
    # 2 防止 gentoo 云镜像 websync 时空间不足
    info "Resize after dd"
    lsblk -f /dev/$xda

    # 打印分区表，并自动修复备份分区表
    fix_gpt_backup_partition_table_by_parted

    disk_size=$(get_disk_size /dev/$xda)
    disk_end=$((disk_size - 1))

    # 不能漏掉最后的 _ ，否则第6部分都划到给 last_part_fs
    IFS=: read -r last_part_num _ last_part_end _ last_part_fs _ \
        < <(parted -msf /dev/$xda 'unit b print' | tail -1)
    last_part_end=$(echo $last_part_end | sed 's/B//')

    if [ $((disk_end - last_part_end)) -ge 0 ]; then
        printf "yes" | parted /dev/$xda resizepart $last_part_num 100% ---pretend-input-tty
        update_part

        mkdir -p /os

        # lvm ?
        # 用 cloud-utils-growpart？
        case "$last_part_fs" in
        ext4)
            # debian ci
            apk add e2fsprogs-extra
            e2fsck -p -f "/dev/$(xda $last_part_num)"
            resize2fs "/dev/$(xda $last_part_num)"
            apk del e2fsprogs-extra
            ;;
        xfs)
            # opensuse ci
            apk add xfsprogs-extra
            mount "/dev/$(xda $last_part_num)" /os
            xfs_growfs "/dev/$(xda $last_part_num)"
            umount /os
            apk del xfsprogs-extra
            ;;
        btrfs)
            # fedora ci
            apk add btrfs-progs
            mount "/dev/$(xda $last_part_num)" /os
            btrfs filesystem resize max /os
            umount /os
            apk del btrfs-progs
            ;;
        ntfs)
            # windows dd
            apk add ntfs-3g-progs
            echo y | ntfsresize "/dev/$(xda $last_part_num)"
            ntfsfix -d "/dev/$(xda $last_part_num)"
            apk del ntfs-3g-progs
            ;;
        esac
        update_part
        parted /dev/$xda -s print
    fi
}

mount_part_basic_layout() {
    local os_dir=$1
    local efi_dir=$2

    if is_efi || is_xda_gt_2t; then
        os_part_num=2
    else
        os_part_num=1
    fi

    # 挂载系统分区
    mkdir -p $os_dir
    mount -t ext4 "/dev/$(xda $os_part_num)" $os_dir

    # 挂载 efi 分区
    if is_efi; then
        mkdir -p $efi_dir
        mount -t vfat -o umask=077 "/dev/$(xda 1)" $efi_dir
    fi
}

mount_part_for_iso_installer() {
    info "Mount part for iso installer"

    if [ "$distro" = windows ]; then
        mount_args="-t ntfs3 -o nocase"
    else
        mount_args=
    fi

    # 挂载主分区
    mkdir -p /os
    mount $mount_args /dev/disk/by-label/os /os

    # 挂载其他分区
    if is_efi; then
        mkdir -p /os/boot/efi
        mount /dev/disk/by-label/efi /os/boot/efi
    fi
    mkdir -p /os/installer
    mount $mount_args /dev/disk/by-label/installer /os/installer
}

get_dns_list_for_win() {
    if dns_list=$(get_current_dns $1); then
        i=0
        for dns in $dns_list; do
            i=$((i + 1))
            echo "set ipv${1}_dns$i=$dns"
        done
    fi
}

create_win_set_netconf_script() {
    target=$1
    info "Create win netconf script"

    if is_staticv4 || is_staticv6 || is_need_manual_set_dnsv6; then
        get_netconf_to mac_addr
        echo "set mac_addr=$mac_addr" >$target

        # 生成静态 ipv4 配置
        if is_staticv4; then
            get_netconf_to ipv4_addr
            get_netconf_to ipv4_gateway
            cat <<EOF >>$target
set ipv4_addr=$ipv4_addr
set ipv4_gateway=$ipv4_gateway
$(get_dns_list_for_win 4)
EOF
        fi

        # 生成静态 ipv6 配置
        if is_staticv6; then
            get_netconf_to ipv6_addr
            get_netconf_to ipv6_gateway
            cat <<EOF >>$target
set ipv6_addr=$ipv6_addr
set ipv6_gateway=$ipv6_gateway
EOF
        fi

        # 有 ipv6 但需设置 dns 的情况
        if is_need_manual_set_dnsv6; then
            cat <<EOF >>$target
$(get_dns_list_for_win 6)
EOF
        fi

        cat -n $target
    fi

    # 脚本还有关闭ipv6隐私id的功能，所以不能省略
    # 合并脚本
    wget $confhome/windows-set-netconf.bat -O- >>$target
    unix2dos $target
}

create_win_change_rdp_port_script() {
    target=$1
    rdp_port=$2

    info "Create win change rdp port script"

    echo "set RdpPort=$rdp_port" >$target
    wget $confhome/windows-change-rdp-port.bat -O- >>$target
    unix2dos $target
}

# virt-what 要用最新版
# vultr 1G High Frequency LAX 实际上是 kvm
# debian 11 virt-what 1.19 显示为 hyperv qemu
# debian 11 systemd-detect-virt 显示为 microsoft
# alpine virt-what 1.25 显示为 kvm
# 所以不要在原系统上判断具体虚拟化环境

# lscpu 也可查看虚拟化环境，但 alpine on lightsail 运行结果为 Microsoft
# 猜测 lscpu 只参考了 cpuid 没参考 dmi
# virt-what 可能会输出多行结果，因此用 grep

get_aws_repo() {
    if is_in_china >&2; then
        echo https://s3.cn-north-1.amazonaws.com.cn/ec2-windows-drivers-downloads-cn
    else
        echo https://s3.amazonaws.com/ec2-windows-drivers-downloads
    fi
}

# 将 AC/SAC 版本号 转换为 LTSC 版本号
# 用于查找驱动
get_windows_name_by_version() {
    local nt_ver=$1
    local build_ver=$2
    local windows_type=$3

    local windows_name
    windows_name=$(
        case "$windows_type" in
        client)
            case "$nt_ver" in
            10.0)
                if [ "$build_ver" -ge 22000 ]; then
                    echo 11
                else
                    echo 10
                fi
                ;;
            6.3) echo 8.1 ;;
            6.2) echo 8 ;;
            6.1) echo 7 ;;
            6.0) echo vista ;;
            esac
            ;;

        server)
            case "$nt_ver" in
            10.0)
                if [ "$build_ver" -ge 26100 ]; then
                    echo 2025
                elif [ "$build_ver" -ge 20348 ]; then
                    echo 2022
                elif [ "$build_ver" -ge 17763 ]; then
                    echo 2019
                else
                    echo 2016
                fi
                ;;
            6.3) echo '2012 r2' ;;
            6.2) echo '2012' ;;
            6.1) echo '2008 r2' ;;
            6.0) echo '2008' ;;
            esac
            ;;
        esac
    )

    if [ -n "$windows_name" ]; then
        echo "$windows_name"
    else
        error_and_exit "Unknown Windows Version: $nt_ver $build_ver $windows_type"
    fi
}

is_nt_ver_ge() {
    local orig sorted
    orig=$(printf '%s\n' "$1" "$nt_ver")
    sorted=$(echo "$orig" | sort -V)
    [ "$orig" = "$sorted" ]
}

# reinstall.sh 有同名方法
is_administrator_username() {
    username_in_lower=$(printf "%s" "$1" | to_lower)

    for builtin_username in \
        administrator \
        administrador \
        administrateur \
        administratör \
        администратор \
        järjestelmänvalvoja \
        rendszergazda; do
        if [ "$username_in_lower" = "$builtin_username" ]; then
            return 0
        fi
    done

    return 1
}

get_cloud_vendor() {
    # busybox blkid 不显示 sr0 的 UUID
    apk add lsblk

    # Manufacturer: Alibaba Cloud
    # Manufacturer: Tencent Cloud
    # Manufacturer: Huawei Cloud
    # Asset Tag: OracleCloud.com
    # Vendor: Amazon EC2
    # Manufacturer: Amazon EC2
    # Asset Tag: Amazon EC2
    # Asset Tag: HUAWEICLOUD

    # http://git.annexia.org/?p=virt-what.git;a=blob;f=virt-what.in;hb=HEAD
    # virt-what 可识别厂商 aws google_cloud alibaba_cloud alibaba_cloud-ebm
    if is_dmi_contains "Amazon EC2" || is_virt_contains aws; then
        echo aws
    elif is_dmi_contains "Google Compute Engine" || is_dmi_contains "GoogleCloud" || is_virt_contains google_cloud; then
        echo gcp
    elif is_dmi_contains "OracleCloud"; then
        echo oracle
    elif is_dmi_contains 'HUAWEICLOUD'; then
        echo huawei
    elif is_dmi_contains 'Alibaba Cloud'; then
        echo aliyun
    elif is_dmi_contains 'Tencent Cloud'; then
        echo qcloud
    elif is_dmi_contains "7783-7084-3265-9085-8269-3286-77"; then
        echo azure
    elif lsblk -o UUID,LABEL | grep -i 9796-932E | grep -iq config-2; then
        echo ibm
    fi
}

get_filesize_mb() {
    du -m "$1" | awk '{print $1}'
}

mkdir_clear() {
    local dir=$1

    if [ -z "$dir" ] || [ "$dir" = / ]; then
        return
    fi

    rm -rf "$dir"
    mkdir -p "$dir"
}

# 注意使用方法是 list=$(list_add "$list" "$item_to_add")
list_add() {
    local list=$1
    local item_to_add=$2
    if [ -n "$list" ]; then
        echo "$list"
    fi
    echo "$item_to_add"
}

is_list_has() {
    local list=$1
    local item=$2
    echo "$list" | grep -qFx "$item"
}

# reinstall.sh 有同名方法
get_drivers() {
    (
        cd "$(readlink -f $1)"
        while ! [ "$(pwd)" = / ]; do
            if [ -d driver ]; then
                if [ -d driver/module ]; then
                    basename "$(readlink -f driver/module)"
                else
                    basename "$(readlink -f driver)"
                fi
            fi
            cd ..
        done
    )
}

get_windows_type_from_windows_drive() {
    local os_dir=$1

    apk add hivex-perl
    system_hive=$(find_file_ignore_case $os_dir/Windows/System32/config/SYSTEM)
    product_type=$(hivexget $system_hive '\ControlSet001\Control\ProductOptions' ProductType)
    apk del hivex-perl

    # ProductType InstallationType 都是用来区分客户端和服务器系统
    # 就驱动而言，用的是 ProductType
    # https://learn.microsoft.com/windows-hardware/drivers/install/inf-manufacturer-section
    # NTamd64.10.0       # 不限制 ProductType
    # NTamd64.10.0.1     # 只接受 ProductType 为 1 的系统

    # 实测也是用 ProductType
    # 在 win11 右键 e1d.inf 安装驱动后，在任务管理器强制为任意网卡选择驱动，列表里面：
    # win11 enterprise    有   i218-V/i-219V，有 i218-LM/i219-LM
    # win11 multi-session 没有 i218-V/i-219V，有 i218-LM/i219-LM

    case "$product_type" in
    WinNT) echo client ;;
    LanmanNT | ServerNT) echo server ;;
    *) error_and_exit "Unexpected Product Type: $product_type" ;;
    esac
}

get_windows_arch_from_windows_drive() {
    local os_dir=$1

    apk add hivex-perl
    hive=$(find_file_ignore_case $os_dir/Windows/System32/config/SYSTEM)
    # 没有 CurrentControlSet
    hivexget $hive 'ControlSet001\Control\Session Manager\Environment' PROCESSOR_ARCHITECTURE
    apk del hivex-perl
}

get_intel_download_url() {
    local id=$1
    local file_regex=$2

    if is_in_china; then
        local url=https://www.intel.cn/content/www/cn/zh/download/$id.html
    else
        local url=https://www.intel.com/content/www/us/en/download/$id.html
    fi

    # 将双引号替换成换行符，使每个链接占一行
    # intel 禁止了 wget 下载网页
    wget -U curl/7.54.1 "$url" -O- | sed 's,",\n,g' |
        grep -Eio -m1 "https://.+/$file_regex" | grep .
}

apk_add_from_edge() {
    # 从 edge/community 仓库下载新版软件包
    # 现在用不到
    local alpine_mirror
    alpine_mirror=$(grep '^http.*/main$' /etc/apk/repositories | sed 's,/[^/]*/main$,,' | head -1)
    apk add --repository "$alpine_mirror/edge/community" \
        --force-non-repository \
        --virtual edge \
        "$@"
}

apk_del_edge() {
    apk del edge
}

install_windows() {
    get_wim_prop() {
        wim=$1
        property=$2

        wiminfo "$wim" | grep -i "^$property:" | cut -d: -f2- | trim
    }

    get_image_prop() {
        wim=$1
        index=$2
        property=$3

        wiminfo "$wim" "$index" | grep -i "^$property:" | cut -d: -f2- | trim
    }

    info "Process windows iso"
    mkdir -p /iso /wim

    # find_file_ignore_case 也在这个文件里面
    # shellcheck disable=SC1090
    . <(wget -O- $confhome/windows-driver-utils.sh)

    apk add wimlib

    download $iso /os/windows.iso
    mount -o ro /os/windows.iso /iso

    sources_boot_wim=$(
        cd /iso
        find_file_ignore_case sources/boot.wim 2>/dev/null ||
            error_and_exit "can't find boot.wim"
    )

    # 一般镜像是 install.wim
    # en_server_install_disc_windows_home_server_2011_x64_dvd_658487.iso 是 Install.wim
    # en_windows_vista_sp2_with_update_6003.23713_aio_7in1_x64_v26.01.13_by_adguard.iso 是 swm
    source_install_wim=$(
        cd /iso
        {
            find_file_ignore_case sources/install.wim ||
                find_file_ignore_case sources/install.esd ||
                find_file_ignore_case sources/install.swm
        } 2>/dev/null || error_and_exit "can't find install.wim, install.esd or install.swm"
    )

    is_swm=false
    if [[ $(echo "$source_install_wim" | to_lower) = '*.swm' ]]; then
        is_swm=true
        swm_ref=$(
            IFS=. read -r name ext < <(basename "$source_install_wim")
            echo "$name*.$ext"
        )
    fi

    # 防止用了不兼容架构的 iso
    boot_index=$(get_wim_prop "/iso/$sources_boot_wim" 'Boot Index')
    arch_wim=$(get_image_prop "/iso/$sources_boot_wim" "$boot_index" 'Architecture' | to_lower)
    if ! {
        { [ "$(uname -m)" = "x86_64" ] && [ "$arch_wim" = x86_64 ]; } ||
            { [ "$(uname -m)" = "x86_64" ] && [ "$arch_wim" = x86 ]; } ||
            { [ "$(uname -m)" = "aarch64" ] && [ "$arch_wim" = arm64 ]; }
    }; then
        error_and_exit "The machine is $(uname -m), but the iso is $arch_wim."
    fi

    # efi 机器不能安装 32 位 windows
    if is_efi && [ "$arch_wim" = x86 ]; then
        error_and_exit "EFI machine can't install 32-bit Windows."
    fi

    iso_install_wim=/iso/$source_install_wim
    install_wim=/os/installer/$source_install_wim

    # 匹配映像版本
    # 需要整行匹配，因为要区分 Windows 10 Pro 和 Windows 10 Pro for Workstations
    image_count=$(wiminfo $iso_install_wim | grep "^Image Count:" | cut -d: -f2 | trim)
    all_image_names=$(wiminfo $iso_install_wim | grep ^Name: | sed 's/^Name: *//')
    info "Images Count: $image_count"
    echo "$all_image_names"
    echo

    if [ "$image_count" = 1 ]; then
        # 只有一个版本就用那个版本
        image_name=$all_image_names
        iso_image_index=1
    else
        while true; do
            # 匹配成功
            # 改成正确的大小写
            if matched_image_name=$(printf '%s\n' "$all_image_names" | grep -Fix "$image_name"); then
                image_name=$matched_image_name
                iso_image_index=$(wiminfo "$iso_install_wim" "$image_name" | grep 'Index:' | awk '{print $NF}')
                break
            fi

            # 匹配失败
            file=/image-name
            error "Invalid image name: $image_name"
            echo "Choose a correct image name by one of follow command in ssh to continue:"
            while read -r line; do
                echo "  echo '$line' >$file"
            done < <(echo "$all_image_names")

            # sleep 直到有输入
            true >$file
            while ! { [ -s $file ] && image_name=$(cat $file) && [ -n "$image_name" ]; }; do
                sleep 1
            done
        done
    fi

    get_selected_image_prop() {
        get_image_prop "$iso_install_wim" "$iso_image_index" "$1"
    }

    # Windows Server 作为域服务器时，ProductType 会变成 LanmanNT ?
    # https://cloud.tencent.com/developer/article/2465206
    # https://github.com/search?q=InstallationType+Client+Embedded+Server+Core&type=code
    # https://learn.microsoft.com/azure/virtual-desktop/windows-multisession-faq#why-does-my-application-report-windows-enterprise-multi-session-as-a-server-operating-system

    # 信息是从注册表获取，因为某些 install.wim 可能缺少属性
    # Azure 上能使用 Windows 10/11 Enterprise 多会话
    # HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\InstallationType
    # HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\ProductOptions\ProductType
    # HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\ProductOptions\ProductSuite

    # 系统                                InstallationType    ProductType    ProductSuite
    # Windows Client (普通 Windows)          Client             WinNT        Terminal Server
    # Windows 10/11 Enterprise 多会话        Client             ServerNT     Terminal Server
    # Windows Server 2012 R2 桌面体验        Server             ServerNT     Terminal Server 和 DataCenter (两行)
    # Windows Server 2012 R2 不带桌面体验    Server Core        ServerNT     Terminal Server 和 DataCenter (两行)
    # Windows Server 2025 桌面体验           Server             ServerNT     Enterprise
    # Windows Server 2025 不带桌面体验       Server Core        ServerNT     Enterprise
    # WES7 / Thin PC                         Embedded           WinNT        Terminal Server

    mount_iso_install_wim_to() {
        local dir=$1

        mkdir -p "$dir"
        # shellcheck disable=SC2046
        wimmount "$iso_install_wim" "$iso_image_index" "$dir" \
            $($is_swm && echo "--ref=$(dirname "$iso_install_wim")/$swm_ref")
    }

    # 挂载 install.wim，检查
    # 1. 是否自带 sac 组件
    # 2. 是否自带 nvme 驱动
    # 3. 是否支持 sha256
    # 4. Installation Type
    mount_iso_install_wim_to /wim

    # 获取版本号
    get_windows_version_from_windows_drive /wim

    # 检测 client/server，并转换成标准版 windows 名称
    # 用于将 Hyper-V Server / Azure Stack HCI / Windows Server AC 的版本号转换成对应的 LTSC 版本号，用于查找驱动
    windows_type=$(get_windows_type_from_windows_drive /wim)
    product_ver=$(get_windows_name_by_version "$nt_ver" "$build_ver" "$windows_type")

    # 检测 sac 和 nvme
    {
        find_file_ignore_case /wim/Windows/System32/sacsess.exe && has_sac=true || has_sac=false
        find_file_ignore_case /wim/Windows/System32/drivers/stornvme.sys && has_stornvme=true || has_stornvme=false
    } >/dev/null 2>&1

    # 检测是否支持 sha256 签名的驱动
    support_sha256=false
    if is_nt_ver_ge 6.2; then
        support_sha256=true
    else
        # 安装环境下 drvload.exe 不会验证签名，能安装 sha256 的驱动
        # 但重启后提示 Windows cannot verify the digital signature for this file.

        # winload.exe/efi 有这串字符
        # Windows cannot verify the digital signature for this file.
        # strings -e l winload.exe | grep -i signature
        # strings -e l winload.efi | grep -i signature

        # 硬盘控制器驱动是 boot-start 驱动，由 winload.exe/efi 验证签名
        # 网卡驱动不是 boot-start 驱动，由 ci.dll 验证签名

        # win7 sp1 iso 不支持 sha256 的驱动，但是
        # ci.dll      能找到 8+64 个常量和 oid 0609608648016503040201 0102040365014886600906
        # winload.exe 能找到 8+64 个常量和 oid 0609608648016503040201 0102040365014886600906
        # winload.efi 能找到 8+64 个常量和 oid     608648016503040201

        # 官网有提到 KB3033929 和 KB4039648, 应该分别是 2008r2 和 2008 最早支持 sha256 的补丁
        # https://support.microsoft.com/kb/4472027#:~:text=KB3033929%20%E5%92%8C%20KB4039648
        # https://support.drweb.cn/sha2
        # https://support.kaspersky.com/common/compatibility/15761
        # https://www.internetdownloadmanager.com/register/new_faq/sha256-support-for-outdated-versions-of-Windows.html
        # https://www.catalog.update.microsoft.com/

        # vista sp2 iso
        # 用 KB4039648 和 KB4090450 做测试，独立安装时，注册表没有发现另一个 KB 的痕迹
        # 后续很多补丁如果包含 winload.exe/efi，都是支持 sha256 的新版，因此不能通过检测 KB 编号来判断
        # HKEY_LOCAL_MACHINE\Microsoft\Windows\CurrentVersion\Component Based Servicing\Package
        # HKEY_LOCAL_MACHINE\Microsoft\Windows\CurrentVersion\Component Based Servicing\PackageDetect

        # vista sp2 iso 独立安装以下补丁时
        # 补丁          发布日期   BuildLabEx          ubr    winload.exe   winload.efi   ci.dll
        # KB4039648 旧  2018/2/21  6002.18005(没改变)  没有   6002.24259    6002.24283    6002.24259
        # KB4039648 新  2018/3/22  6002.18005(没改变)  没有   6002.24259    6002.24298    6002.24259
        # KB4039648-v2  2018/6/12  6002.24381          没有   6002.24362    6002.24381    6002.24259
        # KB4474419-v4  2019/10/8  6003.20555          没有   6003.20505    6003.20555    6003.20593

        # win7 sp1 iso 独立安装以下补丁时
        # KB3033929     2015/3/10  7601.18741          没有   18649/22854  18741/22948    18519/22730
        # KB4474419-v3  2019/9/10  7601.24384          没有         24149        24384          24158

        # 最早的 KB4039648 KB3033929 都支持 sha256
        # winload.exe/efi 版本号 >= ci.dll
        # 因此用 winload.exe/efi 的版本号来判断是否支持 sha256

        apk add pev
        local maj min build rev
        winload=$(find_file_ignore_case "/wim/Windows/System32/winload.$(is_efi && echo efi || echo exe)")
        IFS=. read -r maj min build rev \
            < <(peres -v "$winload" | grep 'Product Version:' | awk '{print $NF}')
        apk del pev

        # vista/2008
        # https://support.microsoft.com/kb/KB4039648
        # https://catalog.update.microsoft.com/Search.aspx?q=KB4039648

        # win7/2008r2 网页有列出文件版本号
        # https://support.microsoft.com/kb/KB3033929
        # https://catalog.update.microsoft.com/Search.aspx?q=KB3033929

        # rev 1xxxx 是 GDR 分支
        # rev 2xxxx 是 LDR 分支

        # vista/2008 版本从 6002 到 6003, rev 减少 4000
        # https://support.microsoft.com/topic/1335e4d4-c155-52eb-4a45-b85bd1909ca8

        if is_efi; then
            if { [ "$maj.$min" = 6.1 ] && [ "$build" -eq 7601 ] && [ "$rev" -ge 22948 ]; } ||
                { [ "$maj.$min" = 6.1 ] && [ "$build" -eq 7601 ] && [ "$rev" -ge 18741 ] && [ "$rev" -lt 20000 ]; } ||
                { [ "$maj.$min" = 6.0 ] && [ "$build" -eq 6003 ] && [ "$rev" -ge 20283 ]; } ||
                { [ "$maj.$min" = 6.0 ] && [ "$build" -eq 6002 ] && [ "$rev" -ge 24283 ]; }; then
                support_sha256=true
            fi
        else
            if { [ "$maj.$min" = 6.1 ] && [ "$build" -eq 7601 ] && [ "$rev" -ge 22854 ]; } ||
                { [ "$maj.$min" = 6.1 ] && [ "$build" -eq 7601 ] && [ "$rev" -ge 18649 ] && [ "$rev" -lt 20000 ]; } ||
                { [ "$maj.$min" = 6.0 ] && [ "$build" -eq 6003 ] && [ "$rev" -ge 20259 ]; } ||
                { [ "$maj.$min" = 6.0 ] && [ "$build" -eq 6002 ] && [ "$rev" -ge 24259 ]; }; then
                support_sha256=true
            fi
        fi
    fi

    wimunmount /wim/

    info "Selected image info"
    echo "Image Name: $image_name"
    echo "Product Version: $product_ver"
    echo "Windows Type: $windows_type"
    echo "NT Version: $nt_ver"
    echo "Build Version: $build_ver"
    echo "Revision Version: $rev_ver"
    echo "-------------------------"
    echo "Has SAC: $has_sac"
    echo "Has StorNVMe: $has_stornvme"
    echo "Support SHA256: $support_sha256"
    echo "-------------------------"
    echo

    # 复制 boot.wim 到 /os，用于临时编辑
    if [ -n "$boot_wim" ]; then
        # 自定义 boot.wim 链接
        download "$boot_wim" /os/boot.wim
    else
        cp /iso/$sources_boot_wim /os/boot.wim
    fi

    # efi 启动目录为 efi 分区
    # bios 启动目录为 os 分区
    if is_efi; then
        boot_dir=/os/boot/efi
    else
        boot_dir=/os
    fi

    # 复制 iso 根目录 boot 开头的文件
    echo 'Copying boot files...'
    find /iso -maxdepth 1 -iname 'boot*' -exec cp -r {} "$boot_dir" \;

    # efi 额外复制 iso 根目录 efi 文件夹
    if is_efi; then
        echo 'Copying efi files...'
        find /iso -maxdepth 1 -type d -iname efi -exec cp -r {} "$boot_dir" \;
    fi

    # 复制iso全部文件(除了boot.wim)到installer分区
    echo 'Copying installer files...'
    if false; then
        # 还需忽略大小写
        rsync -rv \
            --exclude=/sources/boot.wim \
            --exclude=/sources/install.wim \
            --exclude=/sources/install.esd \
            --exclude='/sources/install*.swm' \
            /iso/* /os/installer/
    else
        (
            cd /iso
            find . -type f \
                -not -iname boot.wim \
                -not -iname install.wim \
                -not -iname install.esd \
                -not -iname 'install*.swm' \
                -exec cp -r --parents {} /os/installer/ \;
        )
    fi

    # $iso_image_index 是原 iso 里面的镜像 wim 编号
    # $image_index 是复制到 installer 后的镜像 wim 编号

    # 如果是 swm，要先合并成 wim 才能编辑
    if $is_swm; then
        install_wim=$(echo "$install_wim" | sed 's/\.swm$/.wim/i')
        # 防止不格盘二次运行时报错：文件已存在
        rm -f "$install_wim"
        wimexport --ref="$(dirname "$iso_install_wim")/$swm_ref" "$iso_install_wim" "$iso_image_index" "$install_wim"
        # 只导出了要安装的镜像，因此 image_index 为 1
        image_index=1
    elif false; then
        # 优化 install.wim
        # 优点: 可以节省 200M~600M 空间，用来创建虚拟内存
        #       （意义不大，因为已经删除了 boot.wim 用来创建虚拟内存，vista 除外）
        # 缺点: 如果 install.wim 只有一个镜像，则只能缩小 10M+
        time wimexport --threads "$(get_build_threads 512)" "$iso_install_wim" "$iso_image_index" "$install_wim"
        # 只导出了要安装的镜像，因此 image_index 为 1
        image_index=1
        info "install.wim size"
        echo "Original:  $(get_filesize_mb "$iso_install_wim")"
        echo "Optimized: $(get_filesize_mb "$install_wim")"
        echo
    else
        cp "$iso_install_wim" "$install_wim"
        image_index="$iso_image_index"
    fi

    # win11 要求 1GHz 2核（1核超线程也行）
    # 判断条件是 install.wim 元信息里的 Installation Type，而不是 install.wim 注册表里面的
    # 7601.24214.180801-1700.win7sp1_ldr_escrow_CLIENT_ULTIMATE_x64FRE_en-us.iso wim 没有 Installation Type
    # Vista wim 和 注册表 都没有 InstallationType
    installation_type_from_install_wim_metadata=$(get_selected_image_prop "Installation Type" 2>/dev/null || true)

    # 安装时无法用注册表绕过
    # https://github.com/pbatard/rufus/issues/1990
    # https://learn.microsoft.com/windows/iot/iot-enterprise/Hardware/System_Requirements
    # win11 旧版本安装程序（24h2之前）无法用 setup.exe /product server 跳过 cpu 核数限制，因此在xml里解除限制

    # windows 11 multi-session 用注册表的信息识别成 server 2022 用于匹配驱动，"$product_ver" 是 2022 而不是 11
    # 因此这里判断的条件不是 [ "$product_ver" = "11" ]
    if [ "$build_ver" -ge 22000 ] &&
        [ "$(echo "$installation_type_from_install_wim_metadata" | to_lower)" = "client" ] &&
        [ "$(nproc)" -le 1 ]; then
        wiminfo "$install_wim" "$image_index" --image-property WINDOWS/INSTALLATIONTYPE=Server
    fi

    # 变量名     使用场景
    # arch_uname arch命令 / uname -m                      x86_64   aarch64
    # arch_wim   wiminfo                             x86  x86_64   ARM64
    # arch       virtio iso / unattend.xml / .inf    x86  amd64    arm64
    # arch_xdd   virtio msi / xen驱动                x86   x64
    # arch_dd    华为云驱动                           32    64

    # 将 wim 的 arch 转为驱动和应答文件的 arch
    case "$arch_wim" in
    x86)
        arch=x86
        arch_xdd=x86
        arch_dd=32
        ;;
    x86_64)
        arch=amd64
        arch_xdd=x64
        arch_dd=64
        ;;
    arm64)
        arch=arm64
        arch_xdd= # xen 没有 arm64 驱动，# virtio 也没有 arm64 msi
        arch_dd=  # 华为云没有 arm64 驱动
        ;;
    esac

    # win7 drvload 可以加载 sha256 签名的驱动
    # 但系统安装完重启报错 windows cannot verify the digital signature for this file
    # 需要按 F8 禁用驱动签名

    add_drivers() {
        info "Add drivers"

        # 驱动下载临时文件夹
        drv=/os/drivers
        mkdir_clear "$drv"

        # 这里有坑
        # $(get_cloud_vendor) 调用了 cache_dmi_and_virt
        # 但是 $(get_cloud_vendor) 运行在 subshell 里面
        # subshell 运行结束后里面的变量就消失了
        # 因此先运行 cache_dmi_and_virt
        cache_dmi_and_virt
        vendor="$(get_cloud_vendor)"

        # virtio
        if is_virt_contains virtio; then
            if [ "$vendor" = aliyun ] && is_nt_ver_ge 6.1 && [ "$arch_wim" = x86_64 ]; then
                add_driver_aliyun_virtio
            elif [ "$vendor" = qcloud ] && is_nt_ver_ge 6.1 && [ "$arch_wim" = x86_64 ]; then
                add_driver_qcloud_virtio
            # 未测试是否需要专用驱动
            elif false && [ "$vendor" = huawei ] && is_nt_ver_ge 6.0 && { [ "$arch_wim" = x86 ] || [ "$arch_wim" = x86_64 ]; }; then
                add_driver_huawei_virtio

            # gcp 官方驱动不全，需要用公版补全
            # 官方 windows server 模板没有 viorng 设备，但 linux 模板有
            elif [ "$vendor" = gcp ] && is_nt_ver_ge 6.1 && [ "$arch_wim" = x86 ] && $support_sha256; then
                add_driver_gcp_virtio
                add_driver_generic_virtio \( -iname viorng.inf -or -iname pvpanic.inf \)

            elif [ "$vendor" = gcp ] && is_nt_ver_ge 6.1 && [ "$arch_wim" = x86_64 ] && $support_sha256; then
                add_driver_gcp_virtio
                add_driver_generic_virtio -iname viorng.inf

            elif [ "$vendor" = gcp ] && [ "$nt_ver" = 6.1 ] && [ "$arch_wim" = x86_64 ] && ! $support_sha256; then
                add_driver_gcp_virtio_win6_1_sha1_x64
                add_driver_generic_virtio \( -iname viorng.inf -or -iname balloon.inf \)

            else
                # 兜底
                add_driver_generic_virtio
            fi
        fi

        # xen
        if is_virt_contains xen; then
            # generic_xen 兜底，但未签名，暂停使用
            if is_nt_ver_ge 6.1 && [ "$arch_wim" = x86_64 ]; then
                add_driver_aws_xen
            elif is_nt_ver_ge 6.0 && { [ "$arch_wim" = x86 ] || [ "$arch_wim" = x86_64 ]; }; then
                add_driver_citrix_xen
            fi
        fi

        # vmd
        # RST v17 不支持 vmd
        # RST v18 inf 要求 15063 或以上
        # RST v19 inf 要求 15063 或以上，包含 v18 全部硬件 id
        # RST v20 inf 要求 19041 或以上
        # RST v21 inf 要求 19041 或以上
        if [ -d /sys/module/vmd ] && [ "$build_ver" -ge 15063 ] && [ "$arch_wim" = x86_64 ]; then
            add_driver_vmd
        fi

        # 主网卡，有 IP 地址
        # root@localhost:~# get_drivers /sys/class/net/eth0
        # hv_netvsc

        # 加速网卡，无 IP 地址
        # root@localhost:~# get_drivers /sys/class/net/enP30832s1
        # mana
        # pci_hyperv

        # vpci
        # 对应 linux 的 pci_hyperv
        # win10 ltsc 2021 boot.wim 没有 vpci.sys，导致找不到 azure nvme 硬盘
        # 要从 install.wim 提取
        # PE 下不用上网，因此不需要检测网卡是否用 pci_hyperv
        if [ -d /sys/module/pci_hyperv ] &&
            get_drivers "/sys/block/$xda" | grep -qx pci_hyperv &&
            ! find_file_ignore_case /wim/Windows/System32/drivers/vpci.sys >/dev/null 2>&1; then
            add_driver_vpci
        fi

        # 厂商驱动
        case "$vendor" in
        aws)
            if { [ "$arch_wim" = x86_64 ] || [ "$arch_wim" = arm64 ]; }; then
                add_driver_aws
            fi
            ;;
        azure)
            # inf 不限版本，未测试
            if [ "$arch_wim" = x86_64 ]; then
                add_driver_azure
            fi
            ;;
        gcp)
            # inf 不限版本，6.0 能装但用不了
            # x86 x86_64 arm64 都有
            add_driver_gcp
            ;;
        esac

        # intel 网卡驱动
        # 官网没有提供 vista/2008 驱动
        # win7 驱动 inf/ndis 不支持 vista/2008
        if is_nt_ver_ge 6.1 && { [ "$arch_wim" = x86 ] || [ "$arch_wim" = x86_64 ]; } &&
            grep -iq 8086 /sys/class/net/e*/device/vendor; then
            add_driver_intel_nic
        fi

        # 自定义驱动
        add_driver_custom
    }

    add_driver_intel_nic() {
        info "Add drivers: Intel NIC"

        arch_intel=$(
            case "$arch_wim" in
            x86) echo 32 ;;
            x86_64) echo x64 ;;
            esac
        )

        url=$(
            case "$product_ver" in
            '7' | '2008 r2')
                # 现在官网只有 25.0
                # 25.0 比 24.5 只更新了 ProSet 软件，驱动相同
                # 25.0 有部分文件是 sha256 签名
                # 24.3 全部文件是 sha1 签名
                # https://web.archive.org/web/20250405130938/https://www.intel.com/content/www/us/en/download/15590/29323/intel-network-adapter-driver-for-windows-7-final-release.html
                echo https://downloadmirror.intel.com/18713/eng/prowin${arch_intel}legacy.exe
                ;;
            '8' | '8.1')
                # 之前有 Intel® Network Adapter Driver for Windows 8* - Final Release ，版本 22.7.1
                # 但已被删除，原因不明
                # https://web.archive.org/web/20250501043104/https://www.intel.com/content/www/us/en/download/16765/intel-network-adapter-driver-for-windows-8-final-release.html
                # 27.8 有 NDIS63 文件夹，意味着支持 Windows 8
                # 27.8 相比 22.7.1，可能有些老设备不支持了，但我们不管了
                echo https://downloadmirror.intel.com/764813/Wired_driver_27.8_${arch_intel}.zip
                ;;
            '2012' | '2012 r2')
                echo https://downloadmirror.intel.com/772074/Wired_driver_28.0_${arch_intel}.zip
                ;;
            # 2016 2019 2022 2025 win10 win11
            *) case "${arch_intel}" in
                32)
                    echo https://downloadmirror.intel.com/849483/Wired_driver_30.0.1_${arch_intel}.zip
                    ;;
                x64)
                    id=$(
                        case "$product_ver" in
                        10) echo 18293 ;;
                        11) echo 727998 ;;
                        2016) echo 18737 ;;
                        2019) echo 19372 ;;
                        2022) echo 706171 ;;
                        2025) echo 838943 ;;
                        esac
                    )
                    get_intel_download_url "$id" "(Wired_driver|prowin).*${arch_intel}(legacy)?\.(zip|exe)"
                    ;;
                esac ;;
            esac
        )

        # 注意 intel 禁止了 aria2 下载
        # 还使用了 aws waf，要用浏览器通过 js 获取 aws-waf-token cookie 才能下载
        download_via_browser "$url" $drv/intel.zip

        # inf 可能是 UTF-16 LE？因此用 rg 搜索
        # 用 busybox unzip 解压 win10 驱动时，路径和文件名会粘在一起
        # 但解压 28.0 驱动时，依然会出现这个问题
        # 因此需要 convert_backslashes
        apk add unzip ripgrep

        # https://superuser.com/questions/1382839/zip-files-expand-with-backslashes-on-linux-no-subdirectories
        convert_backslashes() {
            for file in "$1"/*\\*; do
                if [ -f "$file" ]; then
                    target="${file//\\//}"
                    mkdir -p "${target%/*}"
                    mv -v "$file" "$target"
                fi
            done
        }

        # win7 驱动是 .exe 解压不会报错
        # win10 驱动是 .zip 解压反而会报错，目测 zip 文件有问题
        # 在 windows 下解压 win8 的驱动会提示 checksum 错误
        unzip -o -d $drv/intel/ $drv/intel.zip || true
        convert_backslashes $drv/intel

        is_have_inf_in_intel_dir() {
            find $drv/intel -ipath "*/*.inf" | grep . >/dev/null
        }

        # Wired_driver_28.0_x64.zip 需要二次解压
        if ! is_have_inf_in_intel_dir; then
            unzip -o -d $drv/intel/ $drv/intel/Wired_driver_*.exe || true
            convert_backslashes $drv/intel
        fi

        # 由于上面使用了 || true，因此确认下解压后是否有 inf 文件
        if ! is_have_inf_in_intel_dir; then
            error_and_exit "No .inf file found in intel driver package"
        fi

        # Vista RTM 版本号是 6000    NDIS 6.0
        # 2008  RTM 版本号是 6001    NDIS 6.1

        # 找出驱动文件夹对应的最低系统版本
        # 1. 驱动可能限制 windows client/server，但我们不区分
        #    如果装不了也没关系。如果能装但不加载，用户也可以在硬件管理器强制加载驱动
        # 2. 官网写着 win10 驱动要求 RS5 1809，但是驱动包里有 NDIS65 文件夹，也就是支持 10240
        # 3. 有可能 NDIS65 文件夹实际要求 NDIS 6.51？但是先不管
        # https://learn.microsoft.com/en-us/windows-hardware/drivers/network/overview-of-ndis-versions
        min_support_map=$(cat <<EOF |
6000  NDIS60
6001  NDIS61
7600  NDIS62
9200  NDIS63
9600  NDIS64
10240 NDIS65
14393 NDIS66
15063 NDIS67
16299 NDIS68
20348 WS2022
22000 W11
26100 WS2025
EOF
            case "$windows_type" in
            client) grep -E ' (NDIS|W)[0-9]' ;;
            server) grep -E ' (NDIS|WS)[0-9]' ;;
            esac)

        for ethx in $(get_eths); do
            sys_dir=$(get_sys_dir_for_eth $ethx)
            ven=$(cat $sys_dir/vendor | sed 's/^0x//')
            dev=$(cat $sys_dir/device | sed 's/^0x//')
            subsys=$(cat $sys_dir/subsystem_device $sys_dir/subsystem_vendor | sed 's/^0x//' | tr -d '\n')
            rev=$(cat $sys_dir/revision | sed 's/^0x//')

            info "intel nic"
            echo "Ethernet: $ethx"
            echo "Vendor: $ven"
            echo "Device: $dev"
            echo "Subsystem: $subsys"
            echo "Revision: $rev"

            compatible_ids="VEN_$ven&DEV_$dev&SUBSYS_$subsys&REV_$rev"
            compatible_ids="$compatible_ids|VEN_$ven&DEV_$dev&SUBSYS_$subsys"
            compatible_ids="$compatible_ids|VEN_$ven&DEV_$dev&REV_$rev"
            compatible_ids="$compatible_ids|VEN_$ven&DEV_$dev"

            while read -r min_ver ndis; do
                if [ "$build_ver" -ge "$min_ver" ]; then
                    # 只支持 PE?
                    # 有   intel\Release_30.0.zip\PROXGB\Win32\NDIS68\WinPE\*.inf
                    # 没有 intel\Release_30.0.zip\PROXGB\Win32\NDIS68\*.inf

                    # find 只要 $drv/intel 存在返回码就是 0
                    # rg 无需 -E
                    # 非 WinPE 优先
                    if infs=$(find $drv/intel -ipath "*/Win$arch_intel/$ndis/*.inf" -exec rg -iwl "$compatible_ids" {} \; | grep . ||
                        find $drv/intel -ipath "*/Win$arch_intel/$ndis/WinPE/*.inf" -exec rg -iwl "$compatible_ids" {} \; | grep .); then
                        for inf in $infs; do
                            cp_drivers $inf
                        done
                        break
                    fi
                fi
            done < <(echo "$min_support_map" | tac) # 倒序
        done

        apk del unzip ripgrep
    }

    # aws nitro
    # https://s3.amazonaws.com/ec2-windows-drivers-downloads/
    # https://s3.cn-north-1.amazonaws.com.cn/ec2-windows-drivers-downloads-cn/
    # https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/aws-nvme-drivers.html
    # https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/enhanced-networking-ena.html
    # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/other-windows-device-drivers.html
    add_driver_aws() {
        info "Add drivers: AWS"

        download_and_cp_aws_driver() {
            local driver_dir=$1
            local file=$2
            local ver=$3

            local arch_dir
            [ "$arch_wim" = arm64 ] && arch_dir=/ARM64 || arch_dir=

            local unzip_dir=$drv/aws/$driver_dir
            mkdir -p "$unzip_dir"
            download "$(get_aws_repo)/${driver_dir}${arch_dir}/$ver/$file" "$drv/aws/$file"
            unzip -o -d "$unzip_dir" "$drv/aws/$file"
            cp_drivers "$unzip_dir"
        }

        # nvme
        # arm64 的 AWSNVMe.zip 已从服务器删除
        if is_nt_ver_ge 6.1 && [ "$arch_wim" = x86_64 ]; then
            nvme_ver=$(
                case "$nt_ver" in
                6.1) echo 1.3.2 ;; # sha1 签名
                6.2 | 6.3) echo 1.5.1 ;;
                *) echo Latest ;;
                esac
            )
            download_and_cp_aws_driver NVMe AWSNVMe.zip "$nvme_ver"
        fi

        # ena
        # 有 x64 和 amd64
        if is_nt_ver_ge 6.1; then
            ena_ver=$(
                case "$nt_ver" in
                6.1) $support_sha256 && echo 2.2.3 || echo 2.1.4 ;;
                6.2 | 6.3) echo 2.6.0 ;;
                *) echo Latest ;;
                esac
            )
            download_and_cp_aws_driver ENA AwsEnaNetworkDriver.zip "$ena_ver"
        fi

        # vmclock
        # 只有 x64，inf 不限系统版本
        # win8 设备管理器显示的硬件 id 如下
        # ACPI\VEN_AMZN&DEV_C10C
        # ACPI\AMZNC10C
        # *AMZNC10C
        # win7 下少了第一个，第一个也是 inf 里面匹配的，因此 win7 不会自动安装这个驱动，需要手动安装
        if [ "$arch_wim" = x86_64 ] && $support_sha256; then
            # sha256 签名
            download_and_cp_aws_driver AWSVMClock AWSVMClock.zip Latest
        fi

        # serial
        if [ "$arch_wim" = x86_64 ]; then
            # sha1 签名
            download_and_cp_aws_driver AWSPCISerialDriver AWSPCISerialDriver.zip Latest
        fi
    }

    # citrix xen
    add_driver_citrix_xen() {
        info "Add drivers: Citrix Xen"

        apk add 7zip
        download https://s3.amazonaws.com/ec2-downloads-windows/Drivers/Citrix-Win_PV.zip $drv/Citrix-Win_PV.zip
        unzip -o -d $drv $drv/Citrix-Win_PV.zip
        case "$arch_wim" in
        x86) override=s ;;    # skip
        x86_64) override=a ;; # always
        esac
        # 排除 $PLUGINSDIR $TEMP
        exclude='$*'
        7z x $drv/Citrix_xensetup.exe -o$drv/xen/ -ao$override -x!$exclude

        cp_drivers $drv/xen
    }

    # aws xen
    # https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/xen-drivers-overview.html
    add_driver_aws_xen() {
        info "Add drivers: AWS Xen"

        apk add msitools

        # 8.4.3+ 的 xenbus 驱动挑创建实例时的初始系统
        # 初始系统为 windows 的实例支持 8.4.3+
        # 初始系统为 linux 的实例不支持 8.4.3+

        # 初始系统为 linux + 安装 8.4.3
        # 如果用 msi 安装，则不会启用 xenbus，结果是能启动但无法上网
        # 如果通过 inf 安装，则会启用 xenbus，结果是无法启动

        apk add lscpu
        hypervisor_vendor=$(lscpu | grep 'Hypervisor vendor:' | awk '{print $3}')
        apk del lscpu

        aws_pv_ver=$(
            case "$nt_ver" in
            6.1) $support_sha256 && echo 8.3.5 || echo 8.3.2 ;;
            6.2 | 6.3)
                case "$hypervisor_vendor" in
                Xen) echo 8.3.5 ;;       # 实例初始系统为 Linux
                Microsoft) echo 8.4.3 ;; # 实例初始系统为 Windows
                esac
                ;;
            *)
                case "$hypervisor_vendor" in
                Xen) echo 8.3.5 ;;        # 实例初始系统为 Linux
                Microsoft) echo Latest ;; # 实例初始系统为 Windows
                esac
                ;;
            esac
        )

        url=$(
            case "$aws_pv_ver" in
            8.3.2) echo https://web.archive.org/web/20221016194548/https://s3.amazonaws.com/ec2-windows-drivers-downloads/AWSPV/$aws_pv_ver/AWSPVDriver.zip ;; # win7 sha1
            *) echo "$(get_aws_repo)/AWSPV/$aws_pv_ver/AWSPVDriver.zip" ;;
            esac
        )

        download "$url" $drv/AWSPVDriver.zip

        unzip -o -d $drv $drv/AWSPVDriver.zip
        mkdir -p $drv/xen/
        msiextract $drv/AWSPVDriverSetup.msi -C $drv/xen/

        cp_drivers $drv/xen/.Drivers
    }

    # 社区版
    # https://xenbits.xenproject.org/pvdrivers/win/ 未签名
    # https://github.com/xcp-ng/win-pv-drivers/releases

    # 商业版
    # https://pvupdates.vmd.citrix.com/updates.json 7.2.0.1555
    # https://pvupdates.vmd.citrix.com/updates.v9.json 9.3.3.125
    # https://pvupdates.vmd.citrix.com/autoupdate.v1.json 9.3.3.125
    # https://pvupdates.vmd.citrix.com/autoupdate.v2.json 9.6.0.19
    # https://pvupdates.vmd.citrix.com/ 9.6.0.19
    # https://www.xenserver.com/downloads 9.6.0.xx
    # https://docs.xenserver.com/en-us/xenserver/9/vms/windows/vm-tools
    # https://web.archive.org/web/20230830234619/https://support.citrix.com/article/CTX235403/updates-to-citrix-vm-tools-for-windows-for-xenserver-and-citrix-hypervisor

    # 最高版本?
    # 2012 r2   9.3.1
    # 2012      9.3.0
    # 2008 (r2) 7.2.0.1555

    # 9.3.1
    # https://downloads.xenserver.com/vm-tools-windows/9.3.1/managementagentx64.msi
    # http://downloadns.citrix.com.edgesuite.net/17461/managementagentx64.msi

    # 7.2.0.1555
    # http://downloadns.citrix.com.edgesuite.net/14656/managementagentx64.msi
    # http://downloadns.citrix.com.edgesuite.net/14655/managementagentx86.msi

    # xen
    # 没签名，暂时用aws的驱动代替
    # https://lore.kernel.org/xen-devel/E1qKMmq-00035B-SS@xenbits.xenproject.org/
    # https://xenbits.xenproject.org/pvdrivers/win/
    # 在 aws t2 上测试，安装 xenbus 会蓝屏，装了其他7个驱动后，能进系统但没网络
    # 但 aws 应该用aws官方xen驱动，所以测试仅供参考
    add_driver_generic_xen() {
        info "Add drivers: Generic Xen"

        parts='xenbus xencons xenhid xeniface xennet xenvbd xenvif xenvkbd'
        mkdir -p $drv/xen/
        for part in $parts; do
            download https://xenbits.xenproject.org/pvdrivers/win/$part.tar $drv/$part.tar
            tar -xf $drv/$part.tar -C $drv/xen/
        done

        cp_drivers $drv/xen -ipath "*/$arch_xdd/*"
    }

    # virtio
    # https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/
    add_driver_generic_virtio() {
        info "Add drivers: Generic virtio"

        # 要区分 win10 / win11 驱动，虽然他们的 NT 版本号都是 10.0，但驱动文件有区别
        # https://github.com/virtio-win/kvm-guest-drivers-windows/commit/9af43da9e16e2d4bf4ea4663cdc4f29275fff48f
        # vista >>> 2k8
        # 10 >>> w10
        # 2012 r2 >>> 2k12R2
        virtio_sys=$(
            # 没有 vista 文件夹
            if [ "$product_ver" = vista ]; then
                echo 2k8

            # 2k16 2k19 2k22 文件夹没有 arm64 驱动
            elif { [ "$product_ver" = 2016 ] || [ "$product_ver" = 2019 ] || [ "$product_ver" = 2022 ]; } &&
                [ "$arch_wim" = arm64 ]; then
                echo w10

            else
                case "$windows_type" in
                client) echo "w$product_ver" ;;
                server) echo "$product_ver" | sed -E -e 's/ //' -e 's/^200?/2k/' -e 's/r2/R2/' ;;
                esac
            fi
        )

        # win7-drivers 分支 win7 文件夹只有一次提交，也就是 173 全家桶
        # 1. 2020.1.24 https://github.com/virtio-win/virtio-win-pkg-scripts/tree/win7-drivers/data/old-drivers/Win7

        # master 分支 win7 文件夹有 3 次提交，从古到今
        # https://github.com/virtio-win/virtio-win-pkg-scripts/commits/master/data/old-drivers/Win7
        # 1. 2020/6/4  sha256，176 全家桶，相当于没发布的 176 iso
        # 2. 2020/8/10 将部分文件降到 17400，相当于 189~215 iso
        # 3. 2022/4/14 将部分文件降级，相当于 217~最新版 iso

        # 可改成直接从 github commit 下载 win7 173(sha1) 176(sha256) 全家桶？
        # 国内可使用 jsdelivr 加速 github

        # 2k12
        # https://github.com/virtio-win/virtio-win-pkg-scripts/issues/61
        # 217 ~ 271    2k12 证书有问题，红帽的 virtio-win-1.9.45 没问题

        # win7
        # https://fedorapeople.org/groups/virt/virtio-win/repo/stable/
        # https://github.com/virtio-win/virtio-win-pkg-scripts/issues/40
        # 171-1     sha1   稳定版
        # 173-9     sha1   对应上面的 win7-drivers 分支，最后一次编译 win7 + sha1，但不是稳定版?
        # 176       sha256 对应上面的 master-1  最后一次编译 win7，从这次开始是 sha256，此次不提供 iso，编译的文件在之后的 iso 可以找到
        # 185 ~ 187 sha256 正常工作，win7 文件来自 176
        # 189 ~ 215 sha1   对应上面的 master-2  气球版本 17400，vultr 死机
        # 217 ~ 271 sha1   对应上面的 master-3  甲骨文 vioscsi 因硬件 ID 不同用不了，红帽的 virtio-win-1.9.45 也是

        # 甲骨文 vioscsi 硬件 ID 是 PCI\VEN_1AF4&DEV_1004&SUBSYS_0008108E&REV_00
        # SUBSYS 的厂商 ID 是甲骨文

        # virtio-win-0.1.173-9
        # %VirtioScsi.DeviceDesc% = scsi_inst, PCI\VEN_1AF4&DEV_1004&SUBSYS_00081AF4&REV_00, PCI\VEN_1AF4&DEV_1004
        # %VirtioScsi.DeviceDesc% = scsi_inst, PCI\VEN_1AF4&DEV_1048&SUBSYS_11001AF4&REV_01, PCI\VEN_1AF4&DEV_1048

        # stable-virtio
        # %RHELScsi.DeviceDesc% = rhelscsi_inst, PCI\VEN_1AF4&DEV_1004&SUBSYS_00081AF4&REV_00
        # %RHELScsi.DeviceDesc% = rhelscsi_inst, PCI\VEN_1AF4&DEV_1048&SUBSYS_11001AF4&REV_01

        local baseurl=https://fedorapeople.org/groups/virt/virtio-win/direct-downloads

        add_driver_virtio_from_rpm() {
            # fedorapeople 拉黑了华为云，可能有其他厂商也被拉黑
            # DaoCloud 只支持 ipv4
            # 因此这里用 rocky 的 virtio-win rpm 作为 fallback，但只有 x86/x64 驱动

            # rocky 的 virtio-win 比 centos 新
            # https://pkgs.org/download/virtio-win

            info "Add drivers: Generic virtio rpm"

            local ROCKY_RELEASEVER=10

            if is_in_china; then
                local rocky_mirror=https://mirror.nju.edu.cn/rocky
            else
                local rocky_mirror=https://dl.rockylinux.org/pub/rocky
            fi
            local rocky_mirror_os="$rocky_mirror/$ROCKY_RELEASEVER/AppStream/x86_64/os"

            primary_xml_gz=$(wget -O- "$rocky_mirror_os/repodata/repomd.xml" |
                grep -Eo 'repodata/[0-9a-f]+-primary.xml.gz' | grep .)
            virtio_win_rpm_path=$(wget -O- "$rocky_mirror_os/$primary_xml_gz" | zcat |
                grep -Eo 'Packages/v/virtio-win-[^"]+\.noarch\.rpm' | sort -Vr | head -1 | grep .)

            download "$rocky_mirror_os/$virtio_win_rpm_path" $drv/virtio.rpm

            apk add 7zip
            mkdir -p $drv/virtio-rpm/stage $drv/virtio-rpm/root
            7z x $drv/virtio.rpm -o$drv/virtio-rpm/stage -y -bb1
            cpio_file=$(find $drv/virtio-rpm/stage -maxdepth 1 -name '*.cpio' | head -1)
            [ -n "$cpio_file" ] || error_and_exit "Failed to extract virtio-win rpm."
            7z x "$cpio_file" -o$drv/virtio-rpm/root -y -bb1 \
                -i'!./usr/share/virtio-win/drivers/by-driver/*/'"$virtio_sys"'/'"$arch"'/*'
            find $drv/virtio-rpm/root -type f -ipath "*/$virtio_sys/$arch/*.inf" "$@" | grep . >/dev/null ||
                error_and_exit "Can't find $virtio_sys/$arch drivers in virtio-win rpm."
            cp_drivers $drv/virtio-rpm/root "$@"
            apk del 7zip
        }

        get_latest_virtio_dir() {
            local checksum=$1/stable-virtio/CHECKSUM
            local dir

            # 直接读取 CHECKSUM 可以兼容 fedorapeople 跳转和提供文件内容的镜像源
            if dir=$(wget "$checksum" -O- |
                grep -Eo -m1 'virtio-win-[0-9][^[:space:]]+\.noarch\.rpm' |
                sed -E 's,^virtio-win-(.*)\.noarch\.rpm$,archive-virtio/virtio-win-\1,' |
                grep .); then
                echo "$dir"
                return
            fi

            # 保留 Location 解析作为兼容逻辑
            if dir=$(wget --spider -S "$checksum" 2>&1 >/dev/null |
                grep -E '^  Location: ' | grep -Ewo -m1 'archive-virtio/virtio-win-[^/]+'); then
                echo "$dir"
                return
            fi

            return 1
        }

        case "$nt_ver" in
        6.0 | 6.1) $support_sha256 &&
            dir=archive-virtio/virtio-win-0.1.187-1 ||
            dir=archive-virtio/virtio-win-0.1.173-9 ;;        # vista|w7|2k8|2k8R2
        6.2 | 6.3) dir=archive-virtio/virtio-win-0.1.215-2 ;; # w8|w8.1|2k12|2k12R2
        *)
            # 先获取最新版本号，再下载
            # 用 stable-virtio 的话国内镜像下载的可能是缓存的旧版

            # anubis 默认策略拉黑了华为云，连验证的机会都没有

            # https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/
            # 路径是网页，可能会弹出 anubis 验证

            # https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/stable-virtio/CHECKSUM
            # 路径是文件，应该不会弹出 anubis 验证？
            if ! dir=$(get_latest_virtio_dir "$baseurl"); then
                mirror_baseurl=https://files.m.daocloud.io/$(echo "$baseurl" | sed -E 's,^https?://,,i')
                if is_any_ipv4_has_internet && dir=$(get_latest_virtio_dir "$mirror_baseurl"); then
                    baseurl=$mirror_baseurl
                elif [ "$arch_wim" = x86 ] || [ "$arch_wim" = x86_64 ]; then
                    add_driver_virtio_from_rpm "$@"
                    return
                else
                    error_and_exit "Failed to get latest virtio-win version."
                fi
            fi
            # dir=stable-virtio
            ;;
        esac

        # 如果 dir 包含数字，则是从具体版本号文件夹下载，文件不会更新，可以使用国内镜像
        if [[ "$dir" =~ [0-9] ]]; then
            local can_use_cn_mirror=true
        else
            local can_use_cn_mirror=false
        fi

        # vista|w7|2k8|2k8R2|arm64 要从 iso 获取驱动
        if [ "$nt_ver" = 6.0 ] || [ "$nt_ver" = 6.1 ] || [ "$arch_wim" = arm64 ]; then
            virtio_source=iso
        else
            virtio_source=msi
        fi

        if [ "$virtio_source" = iso ]; then
            download $baseurl/$dir/virtio-win.iso $drv/virtio.iso $can_use_cn_mirror
            mkdir -p $drv/virtio
            mount -o ro $drv/virtio.iso $drv/virtio

            # vista 如果安装气动驱动，会报错 windows could not configure one or more system components
            # 2008 安装的气球驱动不能用，需要到硬件管理器重新安装设备才能用，无需更新驱动
            if [ "$product_ver" = vista ]; then
                cp_drivers $drv/virtio -ipath "*/$virtio_sys/$arch/*" "$@" -not -ipath "*/balloon/*"
            else
                cp_drivers $drv/virtio -ipath "*/$virtio_sys/$arch/*" "$@"
            fi
        else
            apk add 7zip file
            download $baseurl/$dir/virtio-win-gt-$arch_xdd.msi $drv/virtio.msi $can_use_cn_mirror
            match="FILE_*_${virtio_sys}_${arch}*"
            7z x $drv/virtio.msi -o$drv/virtio -i!$match -y -bb1
            (
                cd $drv/virtio

                # 为没有后缀名的文件添加后缀名
                echo "Recognizing file extension..."
                for file in *"${virtio_sys}_${arch}"; do
                    recognized=false
                    maybe_exts=$(file -b --extension "$file")

                    # exe/sys -> sys
                    # exe/com -> exe
                    # dll/cpl/tlb/ocx/acm/ax/ime -> dll
                    for ext in sys exe dll; do
                        if echo $maybe_exts | grep -qw $ext; then
                            recognized=true
                            mv -v "$file" "$file.$ext"
                            break
                        fi
                    done

                    # 如果识别不了后缀名，就删除此文件
                    # 因为用不了，免得占用空间
                    if ! $recognized; then
                        rm -fv "$file"
                    fi
                done

                # 将
                # FILE_netkvm_netkvmco_w8.1_amd64.dll
                # FILE_netkvm_w8.1_amd64.cat
                # 改名为
                # netkvmco.dll
                # netkvm.cat
                echo "Renaming files..."
                for file in *; do
                    new_file=$(echo "$file" | sed "s|FILE_||; s|_${virtio_sys}_${arch}||; s|.*_||")
                    mv -v "$file" "$new_file"
                done
            )
            cp_drivers $drv/virtio "$@"
        fi
    }

    add_driver_qcloud_virtio() {
        info "Add drivers: QCloud virtio"

        # 测试版?
        # https://mirrors.tencent.com/install/cts/windows/Drivers.zip

        apk add 7zip
        download https://mirrors.tencent.com/install/windows/virtio_64_1.0.9.exe $drv/virtio.exe true
        exclude='$*' # 排除 $PLUGINSDIR
        override=u   # A(u)to rename all
        7z x $drv/virtio.exe -o$drv/qcloud/ -ao$override -x!$exclude

        # balloon     6.2
        # balloon_1   6.1

        # netkvm      10.0
        # netkvm_1    6.1
        # netkvm_2    6.3

        # viostor     10.0
        # viostor_1   6.1
        # viostor_2   6.2

        drivers=$(
            case "$nt_ver" in
            6.1) echo balloon_1 netkvm_1 viostor_1 ;; # sha1
            6.2) echo balloon netkvm_1 viostor_2 ;;
            6.3) echo balloon netkvm_2 viostor_2 ;;
            *) echo balloon netkvm viostor ;;
            esac
        )

        for old_name in $drivers; do
            part=${old_name%%_*}
            if ! [ "$old_name" = "$part" ]; then
                find $drv/qcloud/$part -type f -iname "$old_name.*" | while read -r file; do
                    ext="${file##*.}"
                    mv -v "$file" "$drv/qcloud/$part/$part.$ext"
                done
            fi
            cp_drivers $drv/qcloud/$part/$part.inf
        done
    }

    add_driver_huawei_virtio() {
        info "Add drivers: Huawei virtio"

        huawei_sys=$(
            case "$(echo "$product_ver" | to_lower)" in
            vista) echo Vista2008 ;;
            7) echo 7 ;;
            8) [ "$arch_wim" = x86 ] && echo 7 || echo 2012 ;;      # 没有 win8 32/64
            8.1) [ "$arch_wim" = x86 ] && echo 7 || echo 2012_R2 ;; # 没有 win8.1 32/64
            10 | 11) echo 10 ;;
            2008) echo Vista2008 ;;
            '2008 r2') echo 2008_R2 ;;
            2012) [ "$arch_wim" = x86 ] && echo 2008_R2 || echo 2012 ;; # 没有 2012 32
            '2012 r2') echo 2012_R2 ;;
            2016 | 2019 | 202*) echo 2016 ;;
            esac
        )

        download https://ecs-instance-driver.obs.cn-north-1.myhuaweicloud.com/vmtools-windows.zip $drv/vmtools-windows.zip
        unzip -o -d $drv $drv/vmtools-windows.zip
        mkdir -p $drv/huawei
        mount -o ro $drv/vmtools-windows.iso $drv/huawei

        cp_drivers $drv/huawei -ipath "*/upgrade/windows ${huawei_sys}_${arch_dd}/drivers/*"
    }

    add_driver_aliyun_virtio() {
        info "Add drivers: Aliyun virtio"

        aliyun_sys=$(
            case "$nt_ver" in
            6.1) echo 2008R2 ;;
            6.2 | 6.3) echo 2012R2 ;; # 实际上是 2012 的驱动
            *) echo 2016 ;;
            esac
        )

        subdir=
        if [ "$nt_ver" = 6.1 ] && ! $support_sha256; then
            subdir=58017/ # sha1
        fi

        region=cn-hangzhou

        download https://windows-driver-$region.oss-$region.aliyuncs.com/virtio/${subdir}AliyunVirtio_WIN$aliyun_sys.zip \
            $drv/AliyunVirtio.zip
        unzip -o -d $drv $drv/AliyunVirtio.zip

        apk add innoextract
        innoextract -d $drv/aliyun/ $drv/AliyunVirtio_*_WIN${aliyun_sys}_$arch_xdd.exe
        apk del innoextract

        cp_drivers $drv/aliyun -ipath "*/C$/Program Files/AliyunVirtio/*/drivers/*"
    }

    # gcp virtio win7 x64 sha1
    # 缺 balloon viorng
    add_driver_gcp_virtio_win6_1_sha1_x64() {
        info "Add drivers: GCP virtio win6.1 sha1 x64"

        # 用到 nvme 时才下载 nvme 驱动
        # 因为 win7 可以通过更新获得 nvme 驱动
        # 而且谷歌推荐使用微软 nvme 驱动
        # (google-compute-engine-driver-nvme 2.0.0 更新内容是删除谷歌 nvme 驱动)
        mkdir -p $drv/gce/win6.1sha1
        for file in \
            WdfCoInstaller01009.dll WdfCoInstaller01011.dll \
            netkvm.inf netkvm.cat netkvm.sys netkvmco.dll \
            pvpanic.inf pvpanic.sys pvpanic.cat \
            vioscsi.inf vioscsi.sys vioscsi.cat \
            $([ -d /sys/module/nvme ] && ! $has_stornvme && echo nvme.inf nvme64.cat nvme.sys); do
            download https://storage.googleapis.com/gce-windows-drivers-public/win6.1sha1/$file $drv/gce/win6.1sha1/$file
        done
        cp_drivers $drv/gce/win6.1sha1
    }

    # gcp virtio win7+ sha256
    # x86 缺 viorng pvpanic
    # x64 缺 viorng
    # https://github.com/GoogleCloudPlatform/compute-image-tools/tree/master/daisy_workflows/image_build/windows
    # 官方是从 https://console.cloud.google.com/storage/browser/gce-windows-drivers-public 下载驱动，安装系统后再 googet 更新驱动
    # 我们一步到位从 googet 下载驱动
    add_driver_gcp_virtio() {
        info "Add drivers: GCP virtio"

        mkdir -p $drv/gce
        gce_repo=https://packages.cloud.google.com/yuck
        download $gce_repo/repos/google-compute-engine-stable/index $drv/gce/gce.json
        for part in balloon netkvm pvpanic vioscsi; do
            # gcp 提供的 pvpanic 没有 x86 驱动
            if [ "$part" = pvpanic ] && [ "$arch_wim" = x86 ]; then
                continue
            fi

            mkdir -p $drv/gce/$part
            link=$(grep -o "/pool/.*-google-compute-engine-driver-$part.*\.goo" $drv/gce/gce.json)
            wget $gce_repo$link -O- | tar xz -C $drv/gce/$part

            [ "$arch_wim" = x86 ] && suffix=-32 || suffix=
            cp_drivers $drv/gce/$part -ipath "*/win$nt_ver$suffix/*"
        done
    }

    # gcp
    # x86 x86_64 arm64 都有
    # win7 驱动是 sha256 签名
    add_driver_gcp() {
        info "Add drivers: GCP"

        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-stable/index
        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-driver-gvnic-stable/index
        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-driver-gga-stable/index
        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-driver-netkvm-stable/index
        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-driver-balloon-stable/index
        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-driver-pvpanic-stable/index
        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-driver-vioscsi-stable/index
        # https://packages.cloud.google.com/yuck/repos/google-compute-engine-driver-nvme-stable/index

        mkdir -p $drv/gce
        gce_repo=https://packages.cloud.google.com/yuck
        download $gce_repo/repos/google-compute-engine-stable/index $drv/gce/gce.json
        for part in gvnic gga; do
            # gvnic 没有 arm64
            if [ "$part" = gvnic ] && [ "$arch_wim" = arm64 ]; then
                continue
            fi

            mkdir -p $drv/gce/$part
            link=$(grep -o "/pool/.*-google-compute-engine-driver-$part.*\.goo" $drv/gce/gce.json)
            wget $gce_repo$link -O- | tar xz -C $drv/gce/$part

            # inf 不限版本
            # 但 win7 gvnic ndis 版本是 6.2，vista/2008 能装但用不了
            # https://github.com/GoogleCloudPlatform/compute-virtual-ethernet-windows/blob/cad1edf7a05465f4972a81f2c015952fd228b5e3/src/gvnic.vcxproj#L298
            if false; then
                for suffix in '' '-32'; do
                    if [ -d "$drv/gce/$part/win6.1$suffix" ]; then
                        cp -r "$drv/gce/$part/win6.1$suffix" "$drv/gce/$part/win6.0$suffix"
                    fi
                done
            fi

            case "$part" in
            gvnic)
                [ "$arch_wim" = x86 ] && suffix=-32 || suffix=
                cp_drivers $drv/gce/gvnic -ipath "*/win$nt_ver$suffix/*"
                ;;
            gga)
                cp_drivers $drv/gce/gga -ipath "*/win$nt_ver/*"
                ;;
            esac
        done
    }

    # azure
    # https://learn.microsoft.com/azure/virtual-network/accelerated-networking-mana-windows
    add_driver_azure() {
        info "Add drivers: Azure"

        download https://aka.ms/manawindowsdrivers $drv/azure.zip
        unzip $drv/azure.zip -d $drv/azure/
        cp_drivers $drv/azure
    }

    # vpci
    add_driver_vpci() {
        info "Add drivers: vpci"

        mount_iso_install_wim_to /wim-tmp

        # 检查 install.wim 镜像是否有 vpci 驱动
        if vpci_sys=$(find_file_ignore_case /wim-tmp/Windows/System32/drivers/vpci.sys) &&
            wvpci_inf=$(find_file_ignore_case /wim-tmp/Windows/INF/wvpci.inf); then

            # 注册表文件
            from_system_hive="$(find_file_ignore_case /wim-tmp/Windows/System32/config/SYSTEM)"
            from_software_hive="$(find_file_ignore_case /wim-tmp/Windows/System32/config/SOFTWARE)"
            to_system_hive="$(find_file_ignore_case /wim/Windows/System32/config/SYSTEM)"
            to_software_hive="$(find_file_ignore_case /wim/Windows/System32/config/SOFTWARE)"

            apk add hivex-perl

            # 获取当前生效的 wvpci.inf 文件
            # 得到 wvpci.inf_amd64_86afbe8940682d27 这样的文件名
            wvpci_inf_filename_with_hash=$(hivexget "$from_system_hive" 'DriverDatabase\DriverInfFiles\wvpci.inf' Active)

            # .inf .sys
            cp -fv "$vpci_sys" "$(get_path_in_correct_case /wim/Windows/System32/drivers/)"
            cp -fv "$wvpci_inf" "$(get_path_in_correct_case /wim/Windows/INF/)"
            cp -rfv "$(get_path_in_correct_case "/wim-tmp/Windows/System32/DriverStore/FileRepository/$wvpci_inf_filename_with_hash/")" \
                "$(get_path_in_correct_case /wim/Windows/System32/DriverStore/FileRepository/)"

            # .cat
            apk add binutils
            for file in "$(get_path_in_correct_case '/wim-tmp/Windows/System32/CatRoot/{F750E6C3-38EE-11D1-85E5-00C04FC295EE}/')"*; do
                if strings -e l "$file" | grep -Fiq vpci.sys; then
                    cp -fv "$file" "$(get_path_in_correct_case '/wim/Windows/System32/CatRoot/{F750E6C3-38EE-11D1-85E5-00C04FC295EE}/')"
                fi
            done
            apk del binutils

            mkdir -p "$drv/vpci"

            # SOFTWARE
            reg=$drv/vpci/software.reg
            # shellcheck disable=SC2043
            for key in \
                "Microsoft\Windows\CurrentVersion\Setup\PnpLockdownFiles\%SystemRoot%/System32/drivers/vpci.sys"; do
                hivexregedit --export "$from_software_hive" "$key" >>"$reg"
            done
            hivexregedit --merge "$to_software_hive" "$reg"

            # SYSTEM
            # 理论上要从 HKEY_LOCAL_MACHINE\SYSTEM\Select 的 Current/Default 获取 ControlSet 序号
            reg=$drv/vpci/system.reg
            for key in \
                "ControlSet001\Services\EventLog\System\vpci" \
                "ControlSet001\Services\vpci" \
                "DriverDatabase\DeviceIds\VMBUS\{44C4F61D-4444-4400-9D52-802E27EDE19F}" \
                "DriverDatabase\DriverInfFiles\wvpci.inf" \
                "DriverDatabase\DriverPackages\\$wvpci_inf_filename_with_hash"; do
                hivexregedit --export "$from_system_hive" "$key" >>"$reg"
            done
            # 这个注册表位置用 Tag 记录着驱动加载的顺序
            # HKEY_LOCAL_MACHINE\System\ControlSet001\Control\GroupOrderList 的 System Bus Extender
            # 因此要删除 vpci 的 tag，避免 tag 跟其他驱动重复，而导致错误
            cat <<EOF >>"$reg"
[\ControlSet001\Services\vpci]
"Tag"=-
EOF
            hivexregedit --merge "$to_system_hive" "$reg"

            apk del hivex-perl
        else
            error_and_exit "vpci driver not found."
        fi

        wimunmount /wim-tmp
    }

    add_driver_vmd() {
        info "Add drivers: VMD"

        local id=
        for d in /sys/bus/pci/devices/*; do
            if [ "$(cat "$d/vendor" 2>/dev/null)" = "0x8086" ] &&
                device=$(sed 's/^0x//' "$d/device" 2>/dev/null); then

                # v21
                if [ "$build_ver" -ge 19041 ] &&
                    [ "$device" = "b06f" ]; then
                    id=920456
                    break

                # v20
                elif [ "$build_ver" -ge 19041 ] &&
                    { [ "$device" = "467f" ] ||
                        [ "$device" = "a77f" ] ||
                        [ "$device" = "7d0b" ] ||
                        [ "$device" = "ad0b" ]; }; then
                    id=849936
                    break

                # v19
                elif [ "$build_ver" -ge 15063 ] &&
                    { [ "$device" = "9a0b" ] ||
                        [ "$device" = "467f" ] ||
                        [ "$device" = "a77f" ]; }; then
                    id=849933
                    break
                fi
            fi
        done

        if [ -n "$id" ]; then
            local url
            url=$(get_intel_download_url "$id" "SetupRST\.exe")

            # 注意 intel 禁止了 aria2 下载
            download_via_browser $url $drv/SetupRST.exe
            apk add 7zip
            7z x $drv/SetupRST.exe -o$drv/SetupRST -i!.text
            7z x $drv/SetupRST/.text -o$drv/vmd
            apk del 7zip
            cp_drivers $drv/vmd
        else
            # 如果开启了 vmd 但硬盘不在 vmd 上，linux 会自动加载 vmd 模块?
            # 还要判断主硬盘是否在 vmd 上，如果不在，即使没有 vmd 驱动也可继续安装
            # 因此目前先不中止脚本
            : error_and_exit "can't find suitable vmd driver"
        fi
    }

    # 脚本自动检测驱动可能有问题
    # 假设是 win7 时代的网卡，官网没有 win10 驱动，系统也不自带
    # 但实际上 win10 可以用 win7 的驱动
    # 这种情况即使脚本自动下载 win10 的驱动包，也不会包含这个驱动
    # 应该下载 win7 的驱动
    # 因此只能交给用户自己添加驱动

    add_driver_custom() {
        if [ -d /custom_drivers/ ]; then
            cp_drivers custom /custom_drivers/
            # 复制后不删除，因为脚本可能再次运行
        fi
    }

    # 修改应答文件
    apk add xmlstarlet
    download $confhome/windows.xml /tmp/autounattend.xml
    locale=$(get_selected_image_prop 'Default Language')
    use_default_rdp_port=$(is_need_change_rdp_port && echo false || echo true)

    # 7601.24214.180801-1700.win7sp1_ldr_escrow_CLIENT_ULTIMATE_x64FRE_en-us.iso Image Name 为空
    # 将 xml Image Name 的值设为空可以正常安装
    sed -i \
        -e "s|%arch%|$arch|" \
        -e "s|%image_name%|$image_name|" \
        -e "s|%locale%|$locale|" \
        -e "s|%use_default_rdp_port%|$use_default_rdp_port|" \
        /tmp/autounattend.xml

    # 账号密码
    if is_administrator_username "$username"; then
        # Administrator
        password_base64=$(get_password_windows_administrator_base64)
        xmlstarlet ed -L -N x="urn:schemas-microsoft-com:unattend" \
            -d "//x:LocalAccounts" \
            /tmp/autounattend.xml
        sed -i \
            -e "s|%enable_administrator%|1|gi" \
            -e "s|%administrator_password%|$password_base64|gi" \
            /tmp/autounattend.xml
    else
        # 普通账号
        password_base64=$(get_password_windows_user_base64)
        xmlstarlet ed -L -N x="urn:schemas-microsoft-com:unattend" \
            -d "//x:AdministratorPassword" \
            /tmp/autounattend.xml
        sed -i \
            -e "s|%enable_administrator%|0|gi" \
            -e "s|%user_username%|$username|gi" \
            -e "s|%user_password%|$password_base64|gi" \
            /tmp/autounattend.xml
    fi

    # 修改应答文件，分区配置
    if is_efi; then
        sed -i "s|%installto_partitionid%|3|" /tmp/autounattend.xml
    else
        sed -i "s|%installto_partitionid%|1|" /tmp/autounattend.xml
    fi

    # vista/2008 有这行安装会报错
    if [ "$nt_ver" = 6.0 ]; then
        sed -i "/EnableFirewall/d" /tmp/autounattend.xml
    fi

    # 2012 r2，删除 key 字段，报错 Windows cannot read the <ProductKey> setting from the unattend answer file，即使创建 ei.cfg
    # ltsc 2021，有 ei.cfg，填空白 key 正常
    # ltsc 2021 n，有 ei.cfg，填空白 key 报错 Windows Cannot find Microsoft software license terms
    # 评估版 iso ei.cfg 有 EVAL 字样，填空白 key 报错 Windows Cannot find Microsoft software license terms

    # key
    if [ "$product_ver" = vista ]; then
        # vista 无人值守安装需要密钥，密钥可与 edition 不一致
        # https://learn.microsoft.com/en-us/windows-server/get-started/kms-client-activation-keys
        # 从镜像获取默认密钥
        setup_cfg=$(get_path_in_correct_case /os/installer/sources/inf/setup.cfg)
        key=$(del_cr <"$setup_cfg" | grep -Eix 'Value=([A-Z0-9]{5}-){4}[A-Z0-9]{5}' | cut -d= -f2 | grep .)
        sed -i "s/%key%/$key/" /tmp/autounattend.xml
    else
        if [ -f "$(get_path_in_correct_case /os/installer/sources/ei.cfg)" ]; then
            # 镜像有 ei.cfg，删除 key 字段
            sed -i "/%key%/d" /tmp/autounattend.xml
        else
            # 镜像无 ei.cfg，填空白 key
            sed -i "s/%key%//" /tmp/autounattend.xml
        fi
    fi

    # 挂载 boot.wim
    info "mount boot.wim"
    wimmountrw /os/boot.wim "$boot_index" /wim/

    # 防止重复
    copyed_infs=
    cp_drivers() {
        if [ "$1" = custom ]; then
            shift
            dst=$(get_path_in_correct_case "/wim/custom_drivers")
        else
            dst=$(get_path_in_correct_case "/wim/drivers")
        fi

        src=$1
        shift

        # -not -iname "*.pdb" \
        # -not -iname "dpinst.exe" \

        # 这里需要在 while 里面变更 $copyed_infs，因此不能用 find | while
        while read -r inf; do
            if ! is_list_has "$copyed_infs" "$inf"; then
                parse_inf_and_cp_driever "$inf" "$dst" "$arch" false
                copyed_infs=$(list_add "$copyed_infs" "$inf")
            fi
        done < <(find $src -type f -iname "*.inf" "$@")
    }

    # 添加驱动
    add_drivers

    # win7 要添加 bootx64.efi 到 efi 目录
    if is_efi; then
        [ $arch = amd64 ] && boot_efi=bootx64.efi || boot_efi=bootaa64.efi

        local src dst
        dst=$(get_path_in_correct_case /os/boot/efi/EFI/boot/$boot_efi)
        if ! [ -f $dst ]; then
            mkdir -p "$(dirname $dst)"
            src=$(get_path_in_correct_case /wim/Windows/Boot/EFI/bootmgfw.efi)
            cp "$src" "$dst"
        fi
    fi

    # 复制应答文件
    # 移除注释，否则 windows-setup.bat 重新生成的 autounattend.xml 有问题
    wim_autounattend_xml=$(get_path_in_correct_case /wim/autounattend.xml)
    wim_windows_xml=$(get_path_in_correct_case /wim/windows.xml)
    wim_setup_exe=$(get_path_in_correct_case /wim/setup.exe)

    xmlstarlet ed -d '//comment()' /tmp/autounattend.xml >$wim_autounattend_xml
    unix2dos $wim_autounattend_xml
    info "autounattend.xml"
    # 查看最终文件，并屏蔽密码
    xmlstarlet ed -d '//*[name()="AdministratorPassword" or name()="Password"]' $wim_autounattend_xml | cat -n

    apk del xmlstarlet

    # 避免无参数运行 setup.exe 时自动安装
    mv $wim_autounattend_xml $wim_windows_xml

    # 复制安装脚本
    # https://slightlyovercomplicated.com/2016/11/07/windows-pe-startup-sequence-explained/
    # https://learn.microsoft.com/previous-versions/windows/it-pro/windows-vista/cc721977(v=ws.10)
    mv $wim_setup_exe $wim_setup_exe.disabled

    # 如果有重复的 Windows/System32 文件夹，会提示找不到 winload.exe 无法引导
    # win7 win10  boot.wim 是 Windows/System32，install.wim 是 Windows/System32
    # win2016     boot.wim 是 windows/system32，install.wim 是 Windows/System32
    # wimmount 无法挂载成忽略大小写

    startnet_cmd=$(get_path_in_correct_case /wim/Windows/System32/startnet.cmd)
    winpeshl_ini=$(get_path_in_correct_case /wim/Windows/System32/winpeshl.ini)

    download $confhome/windows-setup.bat $startnet_cmd
    # dism 手动释放镜像时用
    # sed -i "s|@image_name@|$image_name|" "$startnet.cmd"

    # shellcheck disable=SC2154
    if [ "$force_old_windows_setup" = 1 ]; then
        sed -i 's/ForceOldSetup=0/ForceOldSetup=1/i' $startnet_cmd
    fi

    # 有 SAC 组件时，启用 EMS
    if $has_sac; then
        sed -i 's/EnableEMS=0/EnableEMS=1/i' $startnet_cmd
    fi

    # 4kn EFI 分区最少要 260M
    # https://learn.microsoft.com/windows-hardware/manufacture/desktop/hard-drives-and-partitions
    if is_4kn; then
        sed -i 's/is4kn=0/is4kn=1/i' $startnet_cmd
    fi

    # Windows Thin PC 有 Windows\System32\winpeshl.ini
    # [LaunchApps]
    # %SYSTEMDRIVE%\windows\system32\drvload.exe, %SYSTEMDRIVE%\windows\inf\sdbus.inf
    # %SYSTEMDRIVE%\setup.exe
    if [ -f "$winpeshl_ini" ]; then
        info "mod winpeshl.ini"
        # https://learn.microsoft.com/previous-versions/windows/it-pro/windows-vista/cc721977(v=ws.10)
        # 两种方法都可以，第一种是原版命令
        sed -i 's|setup.exe|windows\\system32\\cmd.exe, "/k %SYSTEMROOT%\\system32\\startnet.cmd"|i' "$winpeshl_ini"
        # sed -i 's|setup.exe|windows\\system32\\startnet.cmd|i' "$winpeshl_ini"
        cat -n "$winpeshl_ini"
    fi

    # 提交修改 boot.wim
    info "Unmount boot.wim"
    wimunmount --commit /wim/

    # 原地优化可以用以下命令之一
    # wimdelete /os/boot.wim 1
    # wimoptimize /os/boot.wim

    # 优化 boot.wim 并复制到正确的位置
    if is_nt_ver_ge 6.1; then
        # win7 或以上删除 boot.wim 镜像 1 不会报错
        # 因为 win7 winre 镜像在 install.wim Windows\System32\Recovery\winRE.wim
        images=$boot_index
    else
        # vista 删除 boot.wim 镜像 1 会报错
        # Windows cannot access the required file Drive:\Sources\Boot.wim.
        # Make sure all files required for installation are available and restart the installation.
        # Error code: 0x80070491
        # vista install.wim 没有 Windows\System32\Recovery\winRE.wim
        images=all
    fi
    mkdir -p "$(get_path_in_correct_case "$(dirname $boot_dir/$sources_boot_wim)")"
    # 防止不格盘二次运行时报错：文件已存在
    rm -f $boot_dir/$sources_boot_wim
    wimexport --boot /os/boot.wim "$images" $boot_dir/$sources_boot_wim
    info "boot.wim size"
    echo "Original:      $(get_filesize_mb /iso/$sources_boot_wim)"
    echo "Added Drivers: $(get_filesize_mb /os/boot.wim)"
    echo "Optimized:     $(get_filesize_mb "$boot_dir/$sources_boot_wim")"
    echo

    # vista 安装时需要 boot.wim，原因见上面
    if [ "$nt_ver" = 6.0 ] &&
        ! [ -e /os/installer/$sources_boot_wim ]; then
        cp $boot_dir/$sources_boot_wim /os/installer/$sources_boot_wim
    fi

    # windows 7 没有 invoke-webrequest
    # installer分区盘符不一定是D盘
    # 所以复制 resize.bat 到 install.wim
    if true; then
        info "mount install.wim"
        wimmountrw $install_wim "$image_index" /wim/
        if false; then
            # 使用 autounattend.xml
            # win7 在此阶段找不到网卡
            download $confhome/windows-resize.bat /wim/windows-resize.bat
            for ethx in $(get_eths); do
                create_win_set_netconf_script /wim/windows-set-netconf-$ethx.bat
            done
        else
            modify_windows /wim
        fi

        info "Unmount install.wim"
        wimunmount --commit /wim/
    fi

    # 添加引导
    if is_efi; then
        # 现在 add_default_efi_to_nvram() 添加 bootx64.efi 到最前面
        # 因此这里重复了
        if false; then
            apk add efibootmgr
            efibootmgr -c -L "Windows Installer" -d /dev/$xda -p1 -l "\\EFI\\boot\\$boot_efi"
        fi
    else
        # 或者用 ms-sys
        apk add grub-bios
        # efi 下，强制安装 mbr 引导，需要添加 --target i386-pc
        grub-install --target i386-pc --boot-directory="$(get_path_in_correct_case /os/boot)" /dev/$xda
        cat <<EOF >"$(get_path_in_correct_case /os/boot/grub/grub.cfg)"
            set timeout=5
            menuentry "reinstall" {
                insmod search
                insmod ntldr
                search --no-floppy --label --set=root os
                ntldr /$(cd /os && get_path_in_correct_case bootmgr)
            }
EOF
    fi
}

# 添加 netboot.efi 备用
download_netboot_xyz_efi() {
    dir=$1
    info "download netboot.xyz.efi"

    file=$dir/netboot.xyz.efi
    if [ "$(uname -m)" = aarch64 ]; then
        download https://boot.netboot.xyz/ipxe/netboot.xyz-arm64.efi $file
    else
        download https://boot.netboot.xyz/ipxe/netboot.xyz.efi $file
    fi
}

refind_main_disk() {
    if true; then
        apk add sfdisk
        main_disk=$(sfdisk --disk-id /dev/$xda | sed 's/0x//')
    else
        apk add lsblk
        # main_disk=$(blkid --match-tag PTUUID -o value /dev/$xda)
        main_disk=$(lsblk --nodeps -rno PTUUID /dev/$xda)
    fi
}

sync_time() {
    if false; then
        # arm要手动从硬件同步时间，避免访问https出错
        # do 机器第二次运行会报错
        hwclock -s || true
    fi

    # ntp 时间差太多会无法同步？
    # http 时间可能不准确，毕竟不是专门的时间服务器
    #      也有可能没有 date header?
    method=http

    case "$method" in
    ntp)
        if is_in_china; then
            ntp_server=ntp.aliyun.com
        else
            ntp_server=pool.ntp.org
        fi
        # -d[d]   Verbose
        # -n      Run in foreground
        # -q      Quit after clock is set
        # -p      PEER
        ntpd -d -n -q -p "$ntp_server"
        ;;
    http)
        url="$(grep -m1 ^http /etc/apk/repositories)/$(uname -m)/APKINDEX.tar.gz"
        # 可能有多行，取第一行
        date_header=$(wget -S --no-check-certificate --spider "$url" 2>&1 | grep -m1 '^  Date:')
        # gnu date 不支持 -D
        busybox date -u -D "  Date: %a, %d %b %Y %H:%M:%S GMT" -s "$date_header"
        ;;
    esac

    # 重启时 alpine 会自动写入到硬件时钟，因此这里跳过
    # hwclock -w
}

is_ubuntu_lts() {
    IFS=. read -r major minor < <(echo "$releasever")
    [ $((major % 2)) = 0 ] && [ $minor = 04 ]
}

get_ubuntu_kernel_flavor() {
    # 20.04/22.04 kvm 内核 vnc 没显示
    # 24.04 kvm = virtual
    # linux-image-virtual = linux-image-6.x-generic
    # linux-image-generic = linux-image-6.x-generic + amd64-microcode + intel-microcode + linux-firmware + linux-modules-extra-generic

    # TODO: ISO virtual-hwe-24.04 不安装 linux-image-extra-virtual-hwe-24.04 不然会花屏

    # https://github.com/systemd/systemd/blob/main/src/basic/virt.c
    # https://github.com/canonical/cloud-init/blob/main/tools/ds-identify
    # http://git.annexia.org/?p=virt-what.git;a=blob;f=virt-what.in;hb=HEAD

    is_ubuntu_lts && suffix=-hwe-$releasever || suffix=

    if [ "$no_cloud_kernel" = 1 ]; then
        echo generic$suffix
        return
    fi

    # 这里有坑
    # $(get_cloud_vendor) 调用了 cache_dmi_and_virt
    # 但是 $(get_cloud_vendor) 运行在 subshell 里面
    # subshell 运行结束后里面的变量就消失了
    # 因此先运行 cache_dmi_and_virt
    cache_dmi_and_virt
    vendor="$(get_cloud_vendor)"
    case "$vendor" in
    aws | gcp | oracle | azure | ibm) echo $vendor ;;
    *)
        if is_virt; then
            echo virtual$suffix
        else
            echo generic$suffix
        fi
        ;;
    esac
}

install_redhat_ubuntu() {
    info "Download iso installer"

    # 安装 grub2
    if is_efi; then
        # 注意低版本的grub无法启动f38 arm的内核
        # https://forums.fedoraforum.org/showthread.php?330104-aarch64-pxeboot-vmlinuz-file-format-changed-broke-PXE-installs
        apk add grub-efi efibootmgr
        grub-install --efi-directory=/os/boot/efi --boot-directory=/os/boot
    else
        apk add grub-bios
        grub-install --boot-directory=/os/boot /dev/$xda
    fi

    # 重新整理 extra，因为grub会处理掉引号，要重新添加引号
    extra_cmdline=''
    for var in $(grep -o '\bextra_[^ ]*' /proc/cmdline | xargs); do
        if [[ "$var" = "extra_main_disk=*" ]]; then
            # 重新记录主硬盘
            refind_main_disk
            extra_cmdline="$extra_cmdline extra_main_disk=$main_disk"
        else
            extra_cmdline="$extra_cmdline $(echo $var | sed -E "s/(extra_[^=]*)=(.*)/\1='\2'/")"
        fi
    done

    # 安装红帽系时，只有最后一个有安装界面显示
    # https://anaconda-installer.readthedocs.io/en/latest/boot-options.html#console
    console_cmdline=$(get_ttys console=)
    grub_cfg=/os/boot/grub/grub.cfg

    # 新版grub不区分linux/linuxefi
    # shellcheck disable=SC2154
    if [ "$distro" = "ubuntu" ]; then
        download $iso /os/installer/ubuntu.iso
        mkdir -p /iso
        mount -o ro /os/installer/ubuntu.iso /iso

        # 内核风味
        kernel=$(get_ubuntu_kernel_flavor)

        # 要安装的版本
        # https://canonical-subiquity.readthedocs-hosted.com/en/latest/reference/autoinstall-reference.html#id
        # 20.04 不能选择 minimal ，也没有 install-sources.yaml
        source_id=
        if [ -f /iso/casper/install-sources.yaml ]; then
            ids=$(grep id: /iso/casper/install-sources.yaml | awk '{print $2}')
            if [ "$(echo "$ids" | wc -l)" = 1 ]; then
                source_id=$ids
            else
                [ "$minimal" = 1 ] && v= || v=-v
                source_id=$(echo "$ids" | grep $v '\-minimal')

                if [ "$(echo "$source_id" | wc -l)" -gt 1 ]; then
                    error_and_exit "find multi source id."
                fi
            fi
        fi

        # 正常写法应该是 ds="nocloud-net;s=https://xxx/" 但是甲骨文云的ds更优先，自己的ds根本无访问记录
        # $seed 是 https://xxx/
        cat <<EOF >$grub_cfg
        set timeout=5
        menuentry "reinstall" {
            # https://bugs.launchpad.net/ubuntu/+source/grub2/+bug/1851311
            # rmmod tpm
            insmod all_video
            insmod search
            insmod loopback
            search --no-floppy --label --set=root installer
            loopback loop /ubuntu.iso
            linux (loop)/casper/vmlinuz iso-scan/filename=/ubuntu.iso autoinstall noprompt noeject cloud-config-url=$ks $extra_cmdline extra_kernel=$kernel extra_source_id=$source_id --- $console_cmdline
            initrd (loop)/casper/initrd
        }
EOF
    else
        download $vmlinuz /os/vmlinuz
        download $initrd /os/initrd.img
        download $squashfs /os/installer/install.img

        cat <<EOF >$grub_cfg
        set timeout=5
        menuentry "reinstall" {
            insmod all_video
            insmod search
            search --no-floppy --label --set=root os
            linux /vmlinuz inst.stage2=hd:LABEL=installer:/install.img inst.ks=$ks $extra_cmdline $console_cmdline
            initrd /initrd.img
        }
EOF
    fi

    cat "$grub_cfg"
}

trans() {
    info "start trans"

    mod_motd

    # 先检查 modloop 是否正常
    # 防止格式化硬盘后，缺少 ext4 模块导致 mount 失败
    # https://github.com/bin456789/reinstall/issues/136
    ensure_service_started modloop

    cat /proc/cmdline
    clear_previous
    add_community_repo

    # 需要在重新分区之前，找到主硬盘
    # 重新运行脚本时，可指定 xda
    # xda=sda ash trans.start
    if [ -z "$xda" ]; then
        find_xda
    fi

    if [ "$distro" != "alpine" ]; then
        setup_web_if_enough_ram
        # util-linux 包含 lsblk
        # util-linux 可自动探测 mount 格式
        apk add util-linux
    fi

    # dd qemu 切换成云镜像模式，暂时没用到
    # shellcheck disable=SC2154
    if [ "$distro" = "dd" ] && [ "$img_type" = "qemu" ]; then
        # 移到 reinstall.sh ?
        distro=any
        cloud_image=1
    fi

    if is_use_cloud_image; then
        case "$img_type" in
        qemu)
            create_part
            download_qcow
            case "$distro" in
            centos | almalinux | rocky | oracle | redhat | anolis | opencloudos | openeuler)
                # 这几个系统云镜像系统盘是8~9g xfs，而我们的目标是能在5g硬盘上运行，因此改成复制系统文件
                install_qcow_by_copy
                ;;
            ubuntu)
                # 24.04 云镜像有 boot 分区（在系统分区之前），因此不直接 dd 云镜像
                install_qcow_by_copy
                ;;
            *)
                # debian fedora opensuse arch gentoo any
                dd_qcow
                resize_after_install_cloud_image
                modify_os_on_disk linux
                ;;
            esac
            ;;
        raw)
            # 暂时没用到 raw 格式的云镜像
            dd_raw_with_extract
            resize_after_install_cloud_image
            modify_os_on_disk linux
            ;;
        esac
    elif [ "$distro" = "dd" ]; then
        case "$img_type" in
        raw)
            dd_raw_with_extract
            if false; then
                # linux 扩容后无法轻易缩小，例如 xfs
                # windows 扩容在 windows 下完成
                resize_after_install_cloud_image
            fi
            if [ -d /configs/cloud-data ]; then
                modify_os_on_disk nocloud
            else
                modify_os_on_disk windows
            fi
            ;;
        qemu) # dd qemu 不可能到这里，因为上面已处理
            ;;
        esac
    else
        # 安装模式
        case "$distro" in
        alpine)
            install_alpine
            ;;
        arch | gentoo | aosc)
            create_part
            install_arch_gentoo_aosc
            ;;
        nixos)
            create_part
            install_nixos
            ;;
        fnos)
            create_part
            install_fnos
            ;;
        *)
            create_part
            mount_part_for_iso_installer
            case "$distro" in
            centos | almalinux | rocky | fedora | ubuntu | redhat) install_redhat_ubuntu ;;
            windows) install_windows ;;
            esac
            ;;
        esac
    fi

    # 需要用到 lsblk efibootmgr ，只要 1M 左右容量
    # 因此 alpine 不单独处理
    if is_efi; then
        del_invalid_efi_entry
        add_default_efi_to_nvram
    fi

    info 'done'
    # 让 web 输出全部内容
    sleep 5
}

# 脚本入口
# debian initrd 会寻找 main
# 并调用本文件的 create_ifupdown_config 方法
: main

# 复制脚本
# 用于打印错误或者再次运行
# 路径相同则不用复制
# 重点：要在删除脚本之前复制
if ! [ "$(readlink -f "$0")" = /trans.sh ]; then
    cp -f "$0" /trans.sh
fi
trap 'trap_err $LINENO $?' ERR

# 删除本脚本，不然会被复制到新系统
rm -f /etc/local.d/trans.start
rm -f /etc/runlevels/default/local

# 提取变量
extract_env_from_cmdline

# 带参数运行部分
# 重新下载并 exec 运行新脚本
if [ "$1" = "update" ]; then
    info 'update script'
    # shellcheck disable=SC2154
    wget -O /trans.sh "$confhome/trans.sh"
    chmod +x /trans.sh
    exec /trans.sh
elif [ "$1" = "alpine" ]; then
    info 'switch to alpine'
    distro=alpine
    # 后面的步骤很多都会用到这个，例如分区布局
    cloud_image=0
elif [ -n "$1" ]; then
    error_and_exit "unknown option $1"
fi

# 无参数运行部分
# 允许 ramdisk 使用所有内存，默认是 50%
mount / -o remount,size=100%

# 同步时间
# 1. 可以防止访问 https 出错
# 2. 可以防止 https://github.com/bin456789/reinstall/issues/223
#    E: Release file for http://security.ubuntu.com/ubuntu/dists/noble-security/InRelease is not valid yet (invalid for another 5h 37min 18s).
#    Updates for this repository will not be applied.
# 3. 不能直接读取 rtc，因为默认情况 windows rtc 是本地时间，linux rtc 是 utc 时间
# 4. 允许同步失败，因为不是关键步骤
sync_time || true

# 安装 ssh 并更改端口
apk add openssh-server
if is_need_change_ssh_port; then
    change_ssh_port / $ssh_port
fi

# 设置密码，添加开机启动 + 开启 ssh 服务
add_user_if_need /
if is_need_set_ssh_keys; then
    set_ssh_keys_and_del_password /
    change_ssh_conf_for_key_login /
    printf '\n' | setup-sshd
else
    change_user_password /
    change_ssh_conf_for_password_login /
    printf '\nyes' | setup-sshd
fi

# 设置 frpc
# 并防止重复运行
if ls /configs/frpc.* >/dev/null 2>&1 && ! pidof frpc >/dev/null; then
    info 'run frpc'
    chmod 600 /configs/frpc.*
    add_community_repo
    apk add frp
    while true; do
        frpc -c /configs/frpc.* || true
        sleep 5
    done &
fi

# shellcheck disable=SC2154
if [ "$hold" = 1 ]; then
    if is_run_from_locald; then
        info "hold"
        exit
    fi
fi

# 正式运行重装
# shellcheck disable=SC2046,SC2194
case 1 in
1)
    # ChatGPT 说这种性能最高
    exec > >(exec tee $(get_ttys /dev/) /reinstall.log) 2>&1
    trans
    ;;
2)
    exec > >(tee $(get_ttys /dev/) /reinstall.log) 2>&1
    trans
    ;;
3)
    trans 2>&1 | tee $(get_ttys /dev/) /reinstall.log
    ;;
esac

if [ "$hold" = 2 ]; then
    info "hold 2"
    exit
fi

# swapoff -a
# umount ?
sync
reboot
FILE_67929f6610795837

# vendor/ttys.sh
cat >"$FLEET_UNPACK/vendor/ttys.sh" <<'FILE_2e6db03cc5022a6f'
#!/bin/sh
prefix=$1

# 不要在 windows 上使用，因为不准确
# 在原系统上使用，也可能不准确？例如安装了 cloud 内核的甲骨文？

# 注意 debian initrd 没有 xargs

# 最后一个 tty 是主 tty，显示的信息最全
if [ "$(uname -m)" = "aarch64" ]; then
    ttys="ttyS0 ttyAMA0 tty0"
else
    ttys="ttyS0 tty0"
fi

# 安装环境下 tty 不一定齐全
# hytron 有ttyS0 但无法写入
# 用于 cmdline 引导参数时，明确排除不可写的 tty，避免 getty 反复重启
# https://github.com/bin456789/reinstall/issues/620

if [ "$prefix" = "console=" ]; then
    is_for_cmdline=true
else
    is_for_cmdline=false
fi

# 用途       条件
# 安装日志   存在且可写
# console    存在且可写 或 不存在（因为安装环境下 tty 不一定齐全）

is_first=true
for tty in $ttys; do
    if { [ -c "/dev/$tty" ] && stty -g -F "/dev/$tty" >/dev/null 2>&1; } ||
        { $is_for_cmdline && ! [ -c "/dev/$tty" ]; }; then
        if $is_first; then
            is_first=false
        else
            printf " "
        fi

        printf "%s" "$prefix$tty"

        if $is_for_cmdline &&
            { [ "$tty" = ttyS0 ] || [ "$tty" = ttyAMA0 ]; }; then
            printf ",115200n8"
        fi
    fi
done
FILE_2e6db03cc5022a6f

# lib/bootstrap-curl.sh
cat >"$FLEET_UNPACK/lib/bootstrap-curl.sh" <<'FILE_86b478219b9a9285'
#!/usr/bin/env bash
ensure_curl() {
    if command -v curl >/dev/null 2>&1 && {
        [[ -s /etc/ssl/certs/ca-certificates.crt ]] ||
        [[ -s /etc/pki/tls/certs/ca-bundle.crt ]] ||
        [[ -s /etc/ssl/ca-bundle.pem ]];
    }; then
        return 0
    fi
    command -v apt-get >/dev/null 2>&1 || {
        printf '%s\n' '缺少 curl 或 CA 证书；请用原系统的包管理器安装 curl 和 ca-certificates。' >&2
        return 1
    }
    printf '%s\n' '正在安装 curl 和 CA 证书……'
    apt-get update && apt-get install -y curl ca-certificates || {
        printf '%s\n' 'curl/证书安装失败，已停止。请检查原系统网络、DNS 和软件源后重试。' >&2
        return 1
    }
    command -v curl >/dev/null 2>&1 || {
        printf '%s\n' '安装后仍找不到 curl，已停止。' >&2
        return 1
    }
}

ensure_host_dependencies() {
    local cmd missing=no
    for cmd in ip lsblk findmnt awk sort readlink grep curl openssl ssh-keygen sha256sum tar gzip cpio; do
        command -v "$cmd" >/dev/null 2>&1 || missing=yes
    done
    if [[ $missing == yes ]]; then
        command -v apt-get >/dev/null 2>&1 || die '缺少必要依赖；非 apt 系统请手动安装 iproute2 util-linux awk coreutils grep curl ca-certificates openssl openssh-client tar gzip cpio'
        apt-get -o DPkg::Lock::Timeout=180 -o Acquire::Retries=3 update || return 1
        apt-get -o DPkg::Lock::Timeout=180 -o Acquire::Retries=3 install -y --no-install-recommends iproute2 util-linux gawk coreutils grep curl ca-certificates openssl openssh-client tar gzip cpio tzdata || return 1
    fi
    ensure_curl || return 1
    for cmd in ip lsblk findmnt awk sort readlink grep curl openssl ssh-keygen sha256sum tar gzip cpio; do
        command -v "$cmd" >/dev/null 2>&1 || die "安装后仍缺少命令：$cmd"
    done
}
FILE_86b478219b9a9285

# SHA256SUMS
cat >"$FLEET_UNPACK/SHA256SUMS" <<'FILE_e6351d3766186d2b'
0738dc4b95db6c739aa816ac99fead8feefb70f543e5b352f38475838a6f9360  lib/adapter.sh
976d9da2e1ab8dc29c10b560afbe30a2dc455e56a3915a60b3b5bd3a651983e2  lib/bootstrap-curl.sh
2bc81ec2c9843007b4f4d40b824d91ac3e6ac93a57fdfd72889d91de8c6cadad  lib/common.sh
3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986  LICENSE
9c287a8c591b63aaaa36c9ecb8bb4113ecef764fc5bbdcd98747771b26852404  payload/assets.tsv
4fb0603fe9837382bcb6f3022e458fedc64c7aaaf2ec1fb54f025756d4ac6416  payload/firstboot.sh
179a313f229f791861e66e6bae90c5d9c0a9d80e602730a95b9be02ccdc72d2e  payload/fleet-firstboot.service
7715b63f837ba843c0bbec6d3687297a15c2b9aecc9c0dfe31a4fafd4f08b23b  payload/fleet-firstboot.timer
24f430c5a64517b15151b181d75df56e4df346f23bfe75ab61a889659a7e8c21  payload/installer-swap.sh
4a10b672dbc6433af77e0106a05e9ca62adfccbe29a3e4b4fd017468681292b0  payload/late.sh
9164dcc56a2012fbaa47cf88a33bd3fdbaf4a9f2e047a5d0d4af52adbf85663c  reinstall.sh
6d7c281c455bccd7b06e8e097ac26e52ebf4daeb4ddd964ab55bea1b66f3a2c5  upstream-changes.patch
721e4ffeb3ca90d8db48229a720d1948c096fdd1917d1731f30e07058e25586c  vendor/debian.cfg
fbad1d795495505aab7498bdcd37824d92040aa8783023844b5f5f848d8cb496  vendor/fix-eth-name.initd
dc667f379b23b13f51f22f8e609bed19e544fcca94b2037faa99bc7f04a90050  vendor/fix-eth-name.service
4b4505ce0ddc40e90dc12d369460136fa9add6cb2dbea6df280650b9517ebd9f  vendor/fix-eth-name.sh
be4193970891e9e1c480b6d8a587f12f27906e65f5486431b88fc0902806e5bc  vendor/get-xda.sh
fff9ffca3222bd637671d541adc74424796835365d2624276927d7632641c78d  vendor/initrd-network.sh
c4a3808e1e2b95ed848e2a69f265c42dd0aae02f86d0394496620165405ef267  vendor/logviewer-nginx.conf
206afddbb05b992ca049720518bab21b4be5ddd82cf3d09c2a26a7517da2b5d4  vendor/logviewer.html
65fcf089d69f554e879cf6435c275915f4569503771e934f3d53b5321191eb00  vendor/reinstall.sh
8224f0c18222c2bf1557c607e1eb7ef24d9f47c782145f67baca8570a6c7e377  vendor/trans.sh
758f059c42008e89dc4df44a8da893aad8980765fa2ae06779224e96c00c3b74  vendor/ttys.sh
FILE_e6351d3766186d2b

(cd "$FLEET_UNPACK" && sha256sum --check --status SHA256SUMS) || {
    printf '%s\n' '源码完整性校验失败，停止。' >&2
    exit 1
}
[[ ${1:-} != --extract-only ]] || exit 0
exec bash "$FLEET_UNPACK/reinstall.sh" "$@"
