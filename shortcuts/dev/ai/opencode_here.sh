


# Suggested OpenCode favorite AI LLM models.
#
# nvidia_nemotron-nano-9b-v2 LM Studio (local)
#
# Devstral-Small-2507-128k-virtuoso Ollama (local)
# Qwen3-Coder-30b-256k-virtuoso Ollama (local)
#
# GPT-5.1 Codex OpenCode Zen
# Gemini 3 Pro OpenCode Zen
# Claude Opus 4.5 OpenCode Zen
# Kimi K2 Thinking OpenCode Zen
#
# GPT-5.1 Codex OpenAI
# o3 OpenAI
#
# openai/gpt-5.1-codex:online OpenRouter
# openai/o3:online OpenRouter
#
# nvidia-nemotron-nano-9b-v2 OpenRouter
# openai/gpt-oss-120b OpenRouter
# openai/gpt-oss-20b OpenRouter
#
# DeepSeek-R1-0528 Hugging Face
#
# openai/gpt-5-pro:online OpenRouter
# o3-pro OpenAI
# llama-3.3-nemotron-super-49b-v1_5 LM Studio (local) (not necessarily OpenCode tool use compatible)


# LM Studio
# https://huggingface.co/bartowski/nvidia_NVIDIA-Nemotron-Nano-9B-v2-GGUF
#  Q8_0

#
#"tools": true,
#"reasoning:": true
#

# TODO: May need to expand the 'buildAuto' prompt to require checking any file writing, editing, etc, if smaller model autonomy really is necessary.

_here_opencode() {
    cat << 'CZXWXcRMTo8EmM8i4d'

{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "prompt": "Additional rules for this environment: use bash semantics, assume MSWindows is Cygwin."
    },
    "plan": {
      "prompt": "Additional rules for this environment: use bash semantics, assume MSWindows is Cygwin."
    },
    "buildAuto": {
      "description": "Explicit opt-in, permissive build agent.",
      "prompt": "Additional rules for this environment: use bash semantics, assume MSWindows is Cygwin, run additional commands if necessary to install dependencies, etc, act routinely such as for file writes, builds, test, etc, without clarifying questions, etc, only ask user when destructive ambiguity exists and the reasonable choices would risk data loss.",
      "tools": {
        "write": true,
        "edit": true,
        "bash": true,
        "webfetch": true,
        "read": true,
        "glob": true,
        "grep": true,
        "format": true,
        "diff": true,
        "test": true,
        "search": true,
        "analyze": true
      },
      "permission": {
        "edit": "allow",
        "bash": "allow",
        "webfetch": "allow",
        "doom_loop": "allow",
        "external_directory": "allow"
      },
      "disable": false
    }
  },
  "provider": {
    "opencode": {
      "options": {
        "apiKey": "{env:OPENCODE_API_KEY}"
      }
    },
    "ollama": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Ollama (local)",
      "options": {
        "baseURL": "http://localhost:11434/v1"
      },
      "models": {
        "Devstral-Small-2507-128k-virtuoso": {
          "name": "Devstral-Small-2507-128k-virtuoso",
          "tools": true
        },
        "Qwen3-Coder-30b-256k-virtuoso": {
          "name": "Qwen3-Coder-30b-256k-virtuoso",
          "tools": true
        },
        "Qwen3-Coder-30b-virtuoso": {
          "name": "Qwen3-Coder-30b-virtuoso",
          "tools": true
        }
      }
    },
    "lmstudio": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "LM Studio  (local)",
      "options": {
        "baseURL": "http://127.0.0.1:1234/v1"
      },
      "models": {
        "nvidia_nvidia-nemotron-nano-9b-v2": {
          "name": "nvidia_nvidia-nemotron-nano-9b-v2",
          "tools": true,
          "reasoning:": true
        },
        "llama-3_3-nemotron-super-49b-v1_5": {
          "name": "llama-3_3-nemotron-super-49b-v1_5",
          "tools": true,
          "reasoning:": true
        },
        "gpt-oss-120b": {
          "name": "gpt-oss-120b",
          "tools": true,
          "reasoning:": true
        },
        "gpt-oss-20b": {
          "name": "gpt-oss-20b",
          "tools": true,
          "reasoning:": true
        }
      }
    },
    "openrouter": {
      "options": {
        "apiKey": "{env:OPENROUTER_API_KEY}"
      },
      "models": {
        "moonshotai/kimi-k2-thinking:online": {
          "name": "moonshotai/kimi-k2-thinking:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "moonshotai/kimi-k2-thinking": {
          "name": "moonshotai/kimi-k2-thinking",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "openai/gpt-5.1-codex:online": {
          "name": "openai/gpt-5.1-codex:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "openai/gpt-5.1:online": {
          "name": "openai/gpt-5.1:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "openai/gpt-5-pro:online": {
          "name": "openai/gpt-5-pro:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "openai/o3:online": {
          "name": "openai/o3:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "google/gemini-3-pro-preview:online": {
          "name": "google/gemini-3-pro-preview:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "deepseek/deepseek-r1-0528:online": {
          "name": "deepseek/deepseek-r1-0528:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "deepseek/deepseek-r1-0528": {
          "name": "deepseek/deepseek-r1-0528",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "nvidia/llama-3.1-nemotron-ultra-253b-v1:online": {
          "name": "nvidia/llama-3.1-nemotron-ultra-253b-v1:online",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "nvidia/llama-3.1-nemotron-ultra-253b-v1": {
          "name": "nvidia/llama-3.1-nemotron-ultra-253b-v1",
          "options": {
            "provider": {
              "sort": "throughput"
            }
          }
        },
        "openai/gpt-oss-120b": {
          "name": "openai/gpt-oss-120b",
          "options": {
            "provider": {
              "sort": "latency",
              "order": ["Groq", "Cerebras", "Amazon Bedrock"]
            }
          }
        },
        "openai/gpt-oss-20b": {
          "name": "openai/gpt-oss-20b",
          "options": {
            "provider": {
              "sort": "latency",
              "order": ["Groq", "Parasail", "Amazon Bedrock"]
            }
          }
        }
      }
    },
    "openai": {
      "options": {
        "apiKey": "{env:OPENAI_API_KEY}"
      }
    },
    "zenmux": {
      "options": {
        "apiKey": "{env:ZENMUX_API_KEY}"
      }
    },
    "huggingface": {
      "options": {
        "apiKey": "{env:HF_API_KEY}"
      }
    }
  }
}

CZXWXcRMTo8EmM8i4d
}




