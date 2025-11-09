package com.example.systrack2.controller;

import com.example.systrack2.DTO.Request.PatioRequestDTO;
import com.example.systrack2.DTO.Response.PatioResponseDTO;
import com.example.systrack2.service.PatioService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@Controller
@RequestMapping("/patios")
@RequiredArgsConstructor
public class PatioController {

    private final PatioService patioService;

    // ================== THYMELEAF PAGES ==================

    // Página de Gerenciar - apenas ADMIN
    @GetMapping("/gerenciar")
    @PreAuthorize("hasRole('ADMIN')")
    public String gerenciarPage(Model model) {
        List<PatioResponseDTO> patios = patioService.listar();
        model.addAttribute("patios", patios);
        return "patios/gerenciar";
    }

    // Página de Listar - ADMIN e USER
    @GetMapping("/listar")
    @PreAuthorize("hasAnyRole('ADMIN','USER')")
    public String listarPage(Model model) {
        List<PatioResponseDTO> patios = patioService.listar();
        model.addAttribute("patios", patios);
        return "patios/listar";
    }

    @GetMapping("/criar")
    @PreAuthorize("hasRole('ADMIN')")
    public String criarPage(Model model) {
        model.addAttribute("patio", new PatioRequestDTO());
        return "patios/criar";
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public String criar(PatioRequestDTO dto, Model model) {
        try {
            patioService.criar(dto);
            return "redirect:/patios/gerenciar";
        } catch (IllegalArgumentException e) {
            model.addAttribute("patio", dto);
            model.addAttribute("erro", e.getMessage());
            return "patios/criar";
        }
    }

    @GetMapping("/editar/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String editarPage(@PathVariable Long id, Model model) {
        PatioResponseDTO patio = patioService.buscarPorId(id);
        model.addAttribute("patio", patio);
        return "patios/editar";
    }

    @PostMapping("/atualizar/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String atualizar(@PathVariable Long id, PatioRequestDTO dto, Model model) {
        try {
            patioService.atualizar(id, dto);
            return "redirect:/patios/gerenciar";
        } catch (IllegalArgumentException e) {
            model.addAttribute("patio", dto);
            model.addAttribute("erro", e.getMessage());
            return "patios/editar";
        }
    }

    @GetMapping("/excluir/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String excluir(@PathVariable Long id) {
        patioService.excluir(id);
        return "redirect:/patios/gerenciar";
    }
}
