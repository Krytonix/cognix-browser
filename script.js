// Wait for DOM to load
document.addEventListener('DOMContentLoaded', () => {

    // 1. Scroll Reveal Animation
    const reveals = document.querySelectorAll('.reveal');

    const revealOptions = {
        threshold: 0.15,
        rootMargin: "0px 0px -50px 0px"
    };

    const revealOnScroll = new IntersectionObserver(function (entries, observer) {
        entries.forEach(entry => {
            if (!entry.isIntersecting) {
                return;
            } else {
                entry.target.classList.add('active');

                observer.unobserve(entry.target);
            }
        });
    }, revealOptions);

    reveals.forEach(reveal => {
        revealOnScroll.observe(reveal);
    });

    // 3. FAQ Accordion
    const faqItems = document.querySelectorAll('.faq-item');

    faqItems.forEach(item => {
        const question = item.querySelector('.faq-question');

        question.addEventListener('click', () => {
            const isActive = item.classList.contains('active');

            // Close all others
            faqItems.forEach(faq => {
                faq.classList.remove('active');
            });

            // Toggle current
            if (!isActive) {
                item.classList.add('active');
            }
        });
    });

    // 5. Navbar Scrolled State
    const navbar = document.querySelector('.navbar');
    window.addEventListener('scroll', () => {
        if (window.scrollY > 50) {
            navbar.style.background = 'rgba(5, 5, 10, 0.95)';
            navbar.style.boxShadow = '0 4px 30px rgba(0, 0, 0, 0.5)';
        } else {
            navbar.style.background = 'rgba(5, 5, 10, 0.8)';
            navbar.style.boxShadow = 'none';
        }
    });

    // Smooth Scroll for anchor links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const href = this.getAttribute('href');
            if (href !== '#') {
                e.preventDefault();
                const target = document.querySelector(href);
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            }
        });
    });

    // Handle Version Selection and Download Links
    const downloadLinks = {
        '3.0.1': 'https://github.com/Krytonix/cognix-browser/releases/tag/v3.0.1', // Default Link
        '2.0.0': 'https://github.com/Krytonix/cognix-browser/releases/tag/v2.0.0', // CHANGE THIS TO YOUR 2.0.0 LINK
        '1.0.0': 'https://github.com/Krytonix/cognix-browser/releases/tag/v1.0.0'  // CHANGE THIS TO YOUR 1.0.0 LINK
    };

    const versionSelects = document.querySelectorAll('.version-select');
    const downloadButtons = document.querySelectorAll('a.btn-primary.btn-massive');

    versionSelects.forEach(select => {
        select.addEventListener('change', (e) => {
            const selectedVersion = e.target.value;
            const link = downloadLinks[selectedVersion];

            // Sync all selects if user changes one
            versionSelects.forEach(s => s.value = selectedVersion);

            // Update main download buttons
            downloadButtons.forEach(btn => {
                if (link) {
                    btn.href = link;
                }
            });
        });
    });

    // Set initial link based on default selection
    if (versionSelects.length > 0 && downloadButtons.length > 0) {
        const initialVersion = versionSelects[0].value;
        const initialLink = downloadLinks[initialVersion];
        if (initialLink) {
            downloadButtons.forEach(btn => btn.href = initialLink);
        }
    }

});
